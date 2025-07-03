-- Location: supabase/migrations/20241216120000_workkar_initial_setup.sql
-- WorkKar Mobile App - Initial Database Setup with Authentication

-- 1. Types and Enums
CREATE TYPE public.user_role AS ENUM ('user', 'worker');
CREATE TYPE public.service_category AS ENUM (
    'electrician', 'plumber', 'carpenter', 'painter', 'mechanic', 
    'cleaner', 'gardener', 'handyman', 'ac_repair', 'appliance_repair'
);
CREATE TYPE public.availability_status AS ENUM ('available', 'busy', 'offline');

-- 2. Core Tables
-- User profiles table (intermediary for auth.users)
CREATE TABLE public.user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    phone TEXT NOT NULL UNIQUE,
    full_name TEXT NOT NULL,
    role public.user_role NOT NULL DEFAULT 'user'::public.user_role,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Workers table (extends user_profiles for worker-specific data)
CREATE TABLE public.workers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    service_category public.service_category NOT NULL,
    pincode TEXT NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    availability public.availability_status DEFAULT 'available'::public.availability_status,
    bio TEXT,
    hourly_rate DECIMAL(10, 2),
    experience_years INTEGER DEFAULT 0,
    profile_image_url TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- User locations for location-based search
CREATE TABLE public.user_locations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    address TEXT,
    pincode TEXT,
    is_current BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Service requests
CREATE TABLE public.service_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    worker_id UUID REFERENCES public.workers(id) ON DELETE CASCADE,
    service_category public.service_category NOT NULL,
    description TEXT NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    address TEXT,
    status TEXT DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 3. Essential Indexes
CREATE INDEX idx_user_profiles_phone ON public.user_profiles(phone);
CREATE INDEX idx_user_profiles_role ON public.user_profiles(role);
CREATE INDEX idx_workers_user_id ON public.workers(user_id);
CREATE INDEX idx_workers_category ON public.workers(service_category);
CREATE INDEX idx_workers_pincode ON public.workers(pincode);
CREATE INDEX idx_workers_availability ON public.workers(availability);
CREATE INDEX idx_workers_location ON public.workers(latitude, longitude);
CREATE INDEX idx_user_locations_user_id ON public.user_locations(user_id);
CREATE INDEX idx_service_requests_user_id ON public.service_requests(user_id);
CREATE INDEX idx_service_requests_worker_id ON public.service_requests(worker_id);

-- 4. RLS Setup
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.service_requests ENABLE ROW LEVEL SECURITY;

-- 5. Helper Functions
-- Check if user has specific role
CREATE OR REPLACE FUNCTION public.has_role(required_role public.user_role)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.user_profiles up
    WHERE up.id = auth.uid() AND up.role = required_role
)
$$;

-- Check if user can access worker profile
CREATE OR REPLACE FUNCTION public.can_access_worker(worker_user_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT auth.uid() = worker_user_id OR public.has_role('user'::public.user_role)
$$;

-- Check if user owns service request
CREATE OR REPLACE FUNCTION public.owns_service_request(request_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.service_requests sr
    WHERE sr.id = request_id AND (sr.user_id = auth.uid() OR sr.worker_id IN (
        SELECT w.id FROM public.workers w WHERE w.user_id = auth.uid()
    ))
)
$$;

-- Function for automatic profile creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO public.user_profiles (id, phone, full_name, role)
  VALUES (
    NEW.id, 
    COALESCE(NEW.phone, ''), 
    COALESCE(NEW.raw_user_meta_data->>'full_name', 'User'),
    COALESCE((NEW.raw_user_meta_data->>'role')::public.user_role, 'user'::public.user_role)
  );
  RETURN NEW;
END;
$$;

-- Function to calculate distance between two points
CREATE OR REPLACE FUNCTION public.calculate_distance(
    lat1 DECIMAL, lng1 DECIMAL, lat2 DECIMAL, lng2 DECIMAL
)
RETURNS DECIMAL
LANGUAGE plpgsql
IMMUTABLE
AS $$
DECLARE
    earth_radius DECIMAL := 6371; -- Earth radius in kilometers
    dlat DECIMAL;
    dlng DECIMAL;
    a DECIMAL;
    c DECIMAL;
BEGIN
    dlat := radians(lat2 - lat1);
    dlng := radians(lng2 - lng1);
    a := sin(dlat/2) * sin(dlat/2) + cos(radians(lat1)) * cos(radians(lat2)) * sin(dlng/2) * sin(dlng/2);
    c := 2 * atan2(sqrt(a), sqrt(1-a));
    RETURN earth_radius * c;
END;
$$;

-- Trigger for new user creation
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 6. RLS Policies
-- User profiles policies
CREATE POLICY "users_view_own_profile"
ON public.user_profiles
FOR SELECT
TO authenticated
USING (auth.uid() = id);

CREATE POLICY "users_update_own_profile"
ON public.user_profiles
FOR UPDATE
TO authenticated
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- Workers policies
CREATE POLICY "workers_view_profiles"
ON public.workers
FOR SELECT
TO authenticated
USING (true);

CREATE POLICY "workers_manage_own_profile"
ON public.workers
FOR ALL
TO authenticated
USING (public.can_access_worker(user_id))
WITH CHECK (public.can_access_worker(user_id));

-- User locations policies
CREATE POLICY "users_manage_own_locations"
ON public.user_locations
FOR ALL
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- Service requests policies
CREATE POLICY "users_view_own_requests"
ON public.service_requests
FOR SELECT
TO authenticated
USING (public.owns_service_request(id));

CREATE POLICY "users_create_requests"
ON public.service_requests
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "users_update_own_requests"
ON public.service_requests
FOR UPDATE
TO authenticated
USING (public.owns_service_request(id))
WITH CHECK (public.owns_service_request(id));

-- 7. Mock Data
DO $$
DECLARE
    user1_auth_id UUID := gen_random_uuid();
    user2_auth_id UUID := gen_random_uuid();
    worker1_auth_id UUID := gen_random_uuid();
    worker2_auth_id UUID := gen_random_uuid();
    worker1_id UUID := gen_random_uuid();
    worker2_id UUID := gen_random_uuid();
BEGIN
    -- Create auth users with required fields
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
        created_at, updated_at, raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous, confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at, email_change_token_new, email_change,
        email_change_sent_at, email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at, phone, phone_change,
        phone_change_token, phone_change_sent_at
    ) VALUES
        (user1_auth_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'user1@example.com', crypt('password123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "John Doe", "role": "user"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, '+919876543210', '', '', null),
        (user2_auth_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'user2@example.com', crypt('password123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Jane Smith", "role": "user"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, '+919876543211', '', '', null),
        (worker1_auth_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'worker1@example.com', crypt('password123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Rajesh Kumar", "role": "worker"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, '+919876543212', '', '', null),
        (worker2_auth_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'worker2@example.com', crypt('password123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Suresh Sharma", "role": "worker"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, '+919876543213', '', '', null);

    -- Create workers
    INSERT INTO public.workers (id, user_id, service_category, pincode, latitude, longitude, availability, bio, hourly_rate, experience_years)
    VALUES
        (worker1_id, worker1_auth_id, 'electrician'::public.service_category, '110001', 28.6139, 77.2090, 'available'::public.availability_status, 'Experienced electrician with 8 years of experience in residential and commercial work.', 500.00, 8),
        (worker2_id, worker2_auth_id, 'plumber'::public.service_category, '110002', 28.6129, 77.2295, 'available'::public.availability_status, 'Professional plumber specializing in pipe repairs and installations.', 450.00, 6);

    -- Create user locations
    INSERT INTO public.user_locations (user_id, latitude, longitude, address, pincode, is_current)
    VALUES
        (user1_auth_id, 28.6139, 77.2090, 'Connaught Place, New Delhi', '110001', true),
        (user2_auth_id, 28.6129, 77.2295, 'India Gate, New Delhi', '110002', true);

    -- Create sample service request
    INSERT INTO public.service_requests (user_id, worker_id, service_category, description, latitude, longitude, address, status)
    VALUES
        (user1_auth_id, worker1_id, 'electrician'::public.service_category, 'Need electrical wiring repair in living room', 28.6139, 77.2090, 'Connaught Place, New Delhi', 'pending');

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Foreign key error: %', SQLERRM;
    WHEN unique_violation THEN
        RAISE NOTICE 'Unique constraint error: %', SQLERRM;
    WHEN OTHERS THEN
        RAISE NOTICE 'Unexpected error: %', SQLERRM;
END $$;

-- 8. Cleanup Function
CREATE OR REPLACE FUNCTION public.cleanup_test_data()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    auth_user_ids_to_delete UUID[];
BEGIN
    -- Get auth user IDs first
    SELECT ARRAY_AGG(id) INTO auth_user_ids_to_delete
    FROM auth.users
    WHERE email LIKE '%@example.com';

    -- Delete in dependency order (children first, then auth.users last)
    DELETE FROM public.service_requests WHERE user_id = ANY(auth_user_ids_to_delete);
    DELETE FROM public.user_locations WHERE user_id = ANY(auth_user_ids_to_delete);
    DELETE FROM public.workers WHERE user_id = ANY(auth_user_ids_to_delete);
    DELETE FROM public.user_profiles WHERE id = ANY(auth_user_ids_to_delete);

    -- Delete auth.users last (after all references are removed)
    DELETE FROM auth.users WHERE id = ANY(auth_user_ids_to_delete);
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Foreign key constraint prevents deletion: %', SQLERRM;
    WHEN OTHERS THEN
        RAISE NOTICE 'Cleanup failed: %', SQLERRM;
END;
$$;
-- ==========================================
-- COFFEE BUDGET TRACKER - SUPABASE SCHEMA
-- ==========================================

-- 1. Enable Row Level Security (RLS) on all tables (to be created below)
-- By default, Supabase requires RLS for tables to be securely accessed from the client

-- --------------------------------------------------------
-- PROFILES TABLE
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  email TEXT NOT NULL,
  display_name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile" 
ON public.profiles FOR SELECT 
USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" 
ON public.profiles FOR UPDATE 
USING (auth.uid() = id);

-- Trigger to automatically create a profile when a new user signs up
CREATE OR REPLACE FUNCTION public.handle_new_user() 
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, display_name)
  VALUES (new.id, new.email, new.raw_user_meta_data->>'full_name');
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Check if trigger exists, if not, create it
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'on_auth_user_created') THEN
    CREATE TRIGGER on_auth_user_created
      AFTER INSERT ON auth.users
      FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
  END IF;
END
$$;

-- --------------------------------------------------------
-- BUDGETS TABLE
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.budgets (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  amount NUMERIC NOT NULL DEFAULT 0,
  month_year TEXT NOT NULL, -- Format: YYYY-MM
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  UNIQUE(user_id, month_year)
);

ALTER TABLE public.budgets ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own budgets" 
ON public.budgets FOR ALL 
USING (auth.uid() = user_id);

-- --------------------------------------------------------
-- TRANSACTIONS TABLE
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.transactions (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  coffee_name TEXT NOT NULL,
  price NUMERIC NOT NULL,
  transaction_date DATE NOT NULL,
  transaction_time TIME,
  location TEXT,
  note TEXT,
  category TEXT DEFAULT 'Lainnya',
  location_lat DOUBLE PRECISION,
  location_lng DOUBLE PRECISION,
  location_source TEXT,
  coffeeshop_id TEXT, -- Optional relation to coffeeshops table
  source TEXT, -- 'manual', 'ocr'
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own transactions" 
ON public.transactions FOR ALL 
USING (auth.uid() = user_id);

-- --------------------------------------------------------
-- COFFEESHOPS TABLE (Global Catalog)
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.coffeeshops (
  id TEXT PRIMARY KEY, -- Can be Google Places ID or UUID
  name TEXT NOT NULL,
  address TEXT NOT NULL,
  image_url TEXT,
  rating DOUBLE PRECISION DEFAULT 0.0,
  vibes TEXT[], -- Array of strings e.g. ['nugas', 'ngechill']
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.coffeeshops ENABLE ROW LEVEL SECURITY;

-- Coffeeshops catalog is readable by everyone
CREATE POLICY "Coffeeshops are readable by all users" 
ON public.coffeeshops FOR SELECT 
USING (true);

-- Only admins/service roles can insert/update (or we allow authenticated users to crowdsource)
CREATE POLICY "Authenticated users can add coffeeshops" 
ON public.coffeeshops FOR INSERT 
WITH CHECK (auth.role() = 'authenticated');

-- --------------------------------------------------------
-- MENU ITEMS TABLE (Global Catalog)
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.menu_items (
  id TEXT PRIMARY KEY,
  coffeeshop_id TEXT REFERENCES public.coffeeshops(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  price NUMERIC NOT NULL,
  category TEXT DEFAULT 'Coffee',
  description TEXT,
  temperature TEXT DEFAULT 'Both',
  strength_level INTEGER DEFAULT 3,
  sweetness_level INTEGER DEFAULT 3,
  milk_types TEXT[],
  flavor_tags TEXT[],
  caffeine_level TEXT DEFAULT 'Medium',
  dietary_tags TEXT[],
  image_url TEXT,
  is_active BOOLEAN DEFAULT true,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.menu_items ENABLE ROW LEVEL SECURITY;

-- Menu items are readable by everyone
CREATE POLICY "Menu items are readable by all users" 
ON public.menu_items FOR SELECT 
USING (true);

-- Authenticated users can insert
CREATE POLICY "Authenticated users can add menu items" 
ON public.menu_items FOR INSERT 
WITH CHECK (auth.role() = 'authenticated');

-- --------------------------------------------------------
-- FAVORITES TABLE
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.favorites (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  item_type TEXT NOT NULL, -- 'coffeeshop' or 'menu_item'
  item_id TEXT NOT NULL, -- Matches coffeeshops.id or menu_items.id
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  UNIQUE(user_id, item_type, item_id)
);

ALTER TABLE public.favorites ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own favorites" 
ON public.favorites FOR ALL 
USING (auth.uid() = user_id);

-- ==========================================
-- END OF SCHEMA
-- ==========================================

-- Define ENUM types
CREATE TYPE lesson_difficulty AS ENUM ('Beginner', 'Intermediate', 'Advanced');
CREATE TYPE exercise_type AS ENUM ('Multiple Choice', 'Fill in the Blank', 'Code');

-- Users Table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Lessons Table
CREATE TABLE lessons (
    lesson_id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    difficulty lesson_difficulty
);

-- Exercises Table
CREATE TABLE exercises (
    exercise_id SERIAL PRIMARY KEY,
    lesson_id INT REFERENCES lessons(lesson_id) ON DELETE CASCADE,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    exercise_type exercise_type
);

-- Progress Table
CREATE TABLE progress (
    progress_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    exercise_id INT REFERENCES exercises(exercise_id) ON DELETE CASCADE,
    completed BOOLEAN DEFAULT FALSE,
    score INT,
    completed_at TIMESTAMP WITH TIME ZONE DEFAULT NULL
);

-- Badge Definitions Table
CREATE TABLE badge_definitions (
    badge_id SERIAL PRIMARY KEY,
    badge_name VARCHAR(50) NOT NULL,
    description TEXT
);

-- User Badges Table (Join Table)
CREATE TABLE user_badges (
    user_badge_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    badge_id INT REFERENCES badge_definitions(badge_id) ON DELETE CASCADE,
    awarded_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, badge_id)
);

-- Add indexes for foreign keys
CREATE INDEX idx_exercises_lesson_id ON exercises(lesson_id);
CREATE INDEX idx_progress_user_id ON progress(user_id);
CREATE INDEX idx_progress_exercise_id ON progress(exercise_id);
CREATE INDEX idx_user_badges_user_id ON user_badges(user_id);
CREATE INDEX idx_user_badges_badge_id ON user_badges(badge_id);

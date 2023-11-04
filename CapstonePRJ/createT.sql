CREATE TABLE users (
  user_id NUMBER DEFAULT USER_SEQ.nextval,
  name VARCHAR2(255),
  email VARCHAR2(255) not null unique,
  password VARCHAR2(255) not null,
  created_at DATE,
  update_at DATE,
  last_login DATE
);

CREATE TABLE profiles (
  profile_id NUMBER default PROFILE_SEQ.nextval,
  user_id NUMBER,
  nick_name VARCHAR2(255),
  created_at DATE,
  update_at DATE
);

CREATE TABLE subscriptions (
  subscription_id NUMBER default SUBSCRIBE_SEQ.nextval,
  user_id NUMBER,
  plan_id NUMBER,
  valid_till DATE,
  created_at DATE,
  update_at DATE
);

CREATE TABLE videos (
  video_id NUMBER default VIDEO_SEQ.nextval,
  title VARCHAR2(255),
  category_id NUMBER,
  upload_date DATE
);

CREATE TABLE plans (
  plan_id NUMBER default PLAN_SEQ.nextval,
  name VARCHAR2(255),
  price NUMBER
);

CREATE TABLE category (
  category_id NUMBER default CATEGORY_SEQ.nextval,
  name VARCHAR2(255)
);

CREATE TABLE views (
  view_id NUMBER default VIEW_SEQ.nextval,
  video_id NUMBER,
  view_count NUMBER,
  update_at DATE
);


CREATE TABLE ratings (
  rating_id NUMBER DEFAULT RATING_SEQ.nextval,
  category_id NUMBER,
  total_view_count NUMBER,
  CONSTRAINT rating_pk PRIMARY KEY (rating_id)
);

ALTER TABLE ratings
ADD CONSTRAINT rating_category_fk FOREIGN KEY (category_id) REFERENCES category(category_id);

ALTER TABLE profiles
ADD CONSTRAINT profile_user_fk FOREIGN KEY (user_id) REFERENCES users (user_id);

ALTER TABLE subscriptions
ADD CONSTRAINT subscription_user_fk FOREIGN KEY (user_id) REFERENCES users (user_id);

ALTER TABLE subscriptions
ADD CONSTRAINT subscription_plan_fk FOREIGN KEY (plan_id) REFERENCES plans (plan_id);

ALTER TABLE videos
ADD CONSTRAINT video_category_fk FOREIGN KEY (category_id) REFERENCES category (category_id);

ALTER TABLE views
ADD CONSTRAINT view_video_fk FOREIGN KEY (video_id) REFERENCES videos (video_id);

ALTER TABLE users
ADD CONSTRAINT users_pk PRIMARY KEY (user_id);

ALTER TABLE profiles
ADD CONSTRAINT profiles_pk PRIMARY KEY (profile_id);

ALTER TABLE subscriptions
ADD CONSTRAINT subscriptions_pk PRIMARY KEY (subscription_id);

ALTER TABLE videos
ADD CONSTRAINT videos_pk PRIMARY KEY (video_id);

ALTER TABLE plans
ADD CONSTRAINT plans_pk PRIMARY KEY (plan_id);

ALTER TABLE category
ADD CONSTRAINT category_pk PRIMARY KEY (category_id);

ALTER TABLE views
ADD CONSTRAINT views_pk PRIMARY KEY (view_id);

ALTER TABLE views
ADD CONSTRAINT unique_title UNIQUE (video_id);


/*

DROP TABLE views;
DROP TABLE category;
DROP TABLE plans;
DROP TABLE videos;
DROP TABLE subscriptions;
DROP TABLE profiles;
DROP TABLE users;
drop table ratings;


*/





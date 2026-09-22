DROP DATABASE IF EXISTS google_play_2026;
CREATE DATABASE google_play_2026;
USE google_play_2026;
/*
2. APPS_METADATA
Arquivo: apps_metadata.csv
Aproximadamente 100.000 registros
*/
CREATE TABLE apps_metadata (
app_id CHAR(10) NOT NULL,
package_name VARCHAR(255) NOT NULL,
app_name VARCHAR(255) NOT NULL,
developer_name VARCHAR(255),
category VARCHAR(100),
installs BIGINT UNSIGNED,
app_size_mb FLOAT,
content_rating VARCHAR(50),
release_date DATE,
latest_version VARCHAR(50),
monetization_type VARCHAR(50),
average_rating FLOAT,
min_android_version VARCHAR(20),
has_in_app_purchases VARCHAR(5),
editor_choice VARCHAR(5),
app_popularity_score FLOAT);
/*
===========================================================
3. USER_BEHAVIOR
Arquivo: user_behavior.csv
Aproximadamente 500000 registros
===========================================================*/
CREATE TABLE user_behavior (
csv_index BIGINT UNSIGNED,
user_id CHAR(9) NOT NULL,
session_id VARCHAR(100) NOT NULL,
app_id CHAR(10) NOT NULL,
session_duration_minutes FLOAT,
daily_usage_time_minutes FLOAT,
clicks INT UNSIGNED,
scrolls INT UNSIGNED,
retention_days INT UNSIGNED,
uninstall_flag TINYINT UNSIGNED,
interaction_timestamp VARCHAR(20),
engagement_score FLOAT,
churn_prediction_score FLOAT,
anomaly_behavior_flag TINYINT UNSIGNED,
fraud_detection_signal TINYINT UNSIGNED,
screen_views INT UNSIGNED,
notification_clicked VARCHAR(5)
);

/*
===========================================================
4. APP_RATINGS_REVIEWS
Arquivo: app_ratings_reviews.csv
Aproximadamente 500.000 registros
===========================================================
*/
CREATE TABLE app_ratings_reviews (
csv_index BIGINT UNSIGNED,
review_id CHAR(12) NOT NULL,
app_id CHAR(10) NOT NULL,
user_id CHAR(9) NOT NULL,
rating FLOAT,
review_text TEXT,
sentiment VARCHAR(20),
helpful_votes INT UNSIGNED,
review_date DATE,
reply_from_dev VARCHAR(5),
thumbs_up INT UNSIGNED,
thumbs_down INT UNSIGNED
);
USE google_play_2026;

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/Users/Clara/Desktop/app_ratings_reviews' 
INTO TABLE user_behavior
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
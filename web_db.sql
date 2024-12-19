CREATE TABLE `USER` (
	`user_id`	INT	NOT NULL,
	`emd_address_id`	INT	NOT NULL,
	`id`	VARCHAR(20)	NOT NULL,
	`pw`	VARCHAR(20)	NOT NULL,
	`name`	VARCHAR(20)	NOT NULL,
	`phone`	VARCHAR(20)	NOT NULL,
	`mail`	VARCHAR(50)	NOT NULL,
	`birth`	DATE	NOT NULL,
	`sex`	CHAR(2)	NOT NULL,
	`image`	BLOB	NULL
);

CREATE TABLE `SIGG_ADDRESS` (
	`sigg_address_id`	INT	NOT NULL,
	`sido_address_id`	INT	NOT NULL,
	`name`	VARCHAR(50)	NOT NULL
);

CREATE TABLE `EMD_ADDRESS` (
	`emd_address_id`	INT	NOT NULL,
	`sigg_address_id`	INT	NOT NULL,
	`name`	VARCHAR(50)	NOT NULL
);

CREATE TABLE `SIDO_ADDRESS` (
	`sido_address_id`	INT	NOT NULL,
	`name`	VARCHAR(50)	NOT NULL
);

CREATE TABLE `JOB_POSTING` (
	`job_id`	INT	NOT NULL,
	`bussiness_detail_id`	INT	NOT NULL,
	`user_id`	INT	NOT NULL,
	`title`	TEXT	NOT NULL,
	`bussiness_content`	TEXT	NOT NULL,
	`address`	VARCHAR(255)	NOT NULL,
	`company`	VARCHAR(30)	NOT NULL,
	`employment_type`	INT	NOT NULL,
	`Recruitment`	INT	NOT NULL,
	`day`	INT	NOT NULL,
	`week`	INT	NOT NULL,
	`time`	VARCHAR(20)	NOT NULL,
	`salary_type`	INT	NOT NULL,
	`salary`	INT	NOT NULL,
	`salary_option`	TEXT	NULL,
	`sex`	TEXT	NOT NULL,
	`age`	TEXT	NOT NULL,
	`academy`	TEXT	NOT NULL,
	`preferential`	TEXT	NULL,
	`end_date`	DATE	NULL,
	`Register_type`	TEXT	NOT NULL,
	`name`	VARCHAR(20)	NOT NULL,
	`mail`	VARCHAR(40)	NOT NULL,
	`phone`	VARCHAR(20)	NOT NULL
);

CREATE TABLE `bussiness_type_detail` (
	`bussiness_detail_id`	INT	NOT NULL,
	`bussiness_id`	INT	NOT NULL,
	`name`	VARCHAR(30)	NOT NULL
);

CREATE TABLE `bussiness_type` (
	`bussiness_id`	INT	NOT NULL,
	`name`	VARCHAR(15)	NOT NULL
);

CREATE TABLE `RESUME` (
	`resume_id`	INT	NOT NULL,
	`user_id`	INT	NOT NULL,
	`emd_address_id`	INT	NOT NULL,
	`bussiness_detail_id`	INT	NOT NULL,
	`title`	TEXT	NOT NULL,
	`academy`	TEXT	NOT NULL,
	`career`	INT	NOT NULL,
	`company_name`	TEXT	NULL,
	`start_date`	DATE	NULL,
	`end_date`	DATE	NULL,
	`working_day`	INT	NULL,
	`result_working_day`	INT	NULL,
	`bussiness`	TEXT	NULL,
	`employment_type`	INT	NOT NULL,
	`day`	INT	NOT NULL,
	`week`	INT	NOT NULL,
	`time`	INT	NOT NULL,
	`salary_type`	INT	NOT NULL,
	`salary`	INT	NOT NULL,
	`salary_option`	INT	NOT NULL,
	`info`	TEXT	NULL
);

CREATE TABLE `MYPAGE` (
	`mypage_id`	INT	NOT NULL,
	`resume_id`	INT	NOT NULL,
	`job_id`	INT	NOT NULL,
	`user_id`	INT	NOT NULL
);

CREATE TABLE `JOB_APPLY` (
	`apply_id`	INT	NOT NULL,
	`user_id`	INT	NOT NULL,
	`job_id`	INT	NOT NULL,
	`resume_id`	INT	NOT NULL,
	`message`	TEXT	NULL
);

CREATE TABLE `TALK_POST` (
	`board_id`	INT	NOT NULL,
	`user_id`	INT	NOT NULL,
	`date`	DATE	NOT NULL,
	`title`	TEXT	NOT NULL,
	`content`	TEXT	NOT NULL,
	`image`	BLOB	NULL,
	`view`	INT	NOT NULL,
	`comment`	INT	NOT NULL
);

CREATE TABLE `COMMENT` (
	`comment_id`	INT	NOT NULL,
	`board_id`	INT	NOT NULL,
	`user_id`	INT	NOT NULL,
	`date`	DATE	NOT NULL,
	`content`	TEXT	NOT NULL
);

ALTER TABLE `USER` ADD CONSTRAINT `PK_USER` PRIMARY KEY (
	`user_id`
);

ALTER TABLE `SIGG_ADDRESS` ADD CONSTRAINT `PK_SIGG_ADDRESS` PRIMARY KEY (
	`sigg_address_id`
);

ALTER TABLE `EMD_ADDRESS` ADD CONSTRAINT `PK_EMD_ADDRESS` PRIMARY KEY (
	`emd_address_id`
);

ALTER TABLE `SIDO_ADDRESS` ADD CONSTRAINT `PK_SIDO_ADDRESS` PRIMARY KEY (
	`sido_address_id`
);

ALTER TABLE `JOB_POSTING` ADD CONSTRAINT `PK_JOB_POSTING` PRIMARY KEY (
	`job_id`
);

ALTER TABLE `bussiness_type_detail` ADD CONSTRAINT `PK_BUSSINESS_TYPE_DETAIL` PRIMARY KEY (
	`bussiness_detail_id`
);

ALTER TABLE `bussiness_type` ADD CONSTRAINT `PK_BUSSINESS_TYPE` PRIMARY KEY (
	`bussiness_id`
);

ALTER TABLE `RESUME` ADD CONSTRAINT `PK_RESUME` PRIMARY KEY (
	`resume_id`
);

ALTER TABLE `MYPAGE` ADD CONSTRAINT `PK_MYPAGE` PRIMARY KEY (
	`mypage_id`
);

ALTER TABLE `JOB_APPLY` ADD CONSTRAINT `PK_JOB_APPLY` PRIMARY KEY (
	`apply_id`
);

ALTER TABLE `TALK_POST` ADD CONSTRAINT `PK_TALK_POST` PRIMARY KEY (
	`board_id`
);

ALTER TABLE `COMMENT` ADD CONSTRAINT `PK_COMMENT` PRIMARY KEY (
	`comment_id`
);


<?php
/**
 * lovemi.jpから、ユーザー移植スクリプト
 */

/* 移植順と実現方法
1.lovemi.jpから、相関のテーブルをFsfortuneにコピー,テーブル名はold_*のように変更,lovemi.jpはSjisのコーディングですので、普通のpg_dump/psql利用しません

　　lovemi.jp側の相関テーブル：
　　user_mst,official_regist_dat,official_course_log_dat,campaign_total_dat,lifetime_log_dat

echo '' > /home/fortune/lovemi.user.txt;
echo '<?php
require_once("/home/fortune/contents/user/public_html/user_include.inc");
ini_set("memory_limit","512M");
$db = &FortuneDBManager::getInstance();
$tables = "user_mst,official_regist_dat,official_point_dat,campaign_total_dat,lifetime_log_dat";
$table_name_array = explode(",", $tables);
$tmp_array = array();
foreach ($table_name_array as $table_name) {
	$sql = "select * from {$table_name} where delete_flg=false;";
	$data = $db->executeQuery($sql);
	$tmp_array[$table_name] = $data;
}
file_put_contents("/home/fortune/lovemi.user.txt", base64_encode(serialize($tmp_array)));
?>' > ~/lovemi.user.php;
/usr/local/bin/php /home/fortune/lovemi.user.php;
gzip /home/fortune/lovemi.user.txt


　　上記の方法で、相関のテーブルをFsfortuneにコピー
　　fsfortuneで
gunzip /home/fsfortune/lovemi.user.txt.gz

2.fsfortuneで、下記のスクリプトを行う
/usr/local/bin/php /home/fsfortune/copy_user.php
 */

// クラス、設定読み込み
require_once("/home/fsfortune/user/public_html/user_include.inc");
## touch /home/fsfortune/logs/temp_php_error.log
## chmod 777 /home/fsfortune/logs/temp_php_error.log
## ini_set("error_log", "/home/fsfortune/logs/temp_php_error.log");
set_time_limit(0);
ini_set("memory_limit","512M");// メモリ足らない時、臨時テーブルを使いましょう？

$contents = file_get_contents("/home/fsfortune/lovemi.user.txt");
$tmp_array = unserialize(base64_decode($contents));
$db = &FsfortuneDBManager::getInstance();

// コース整理
$monthly_course_array = array();
$monthly_course_array[1] = array(Carrier::DOCOMO,	"d9022801");
$monthly_course_array[4] = array(Carrier::AU, 		"kccs40002");
$monthly_course_array[7] = array(Carrier::SOFTBANK,	"sbE4QG"); // もう利用しません
$monthly_course_array[8] = array(Carrier::SOFTBANK,	"sbEIO4");

$extra_course_array = array(); // 従量使用していません、無視


/***********************************
 * 
//*/

// 初期化、データクリア(user_mst,regist_course_log_dat,user_point_dat,campaign_total_dat,lifetime_total_dat,regist_course_total_day_dat)
$sql = <<<SQL
truncate user_mst;
truncate regist_course_log_dat;
truncate user_point_dat;
truncate campaign_total_dat;
truncate lifetime_total_dat;
truncate regist_course_total_day_dat;

select setval('user_mst_id_seq', 1, false);
select setval('regist_course_log_dat_id_seq', 1, false);
select setval('user_point_dat_id_seq', 1, false);
select setval('campaign_total_dat_id_seq', 1, false);
select setval('lifetime_total_dat_id_seq', 1, false);
select setval('regist_course_total_day_dat_id_seq', 1, false);
SQL;
$db->executeQuery($sql);


// lovemi.jpのuser_mstをfsfortuneにコピー、IDも保持
$old_table_name = "user_mst";
$new_table_name = "user_mst";
$old_user_list = $tmp_array[$old_table_name];
foreach ($old_user_list as $old_user_mst) {
	$v_param = array();
	$v_param["id"] = $old_user_mst["id"];
	$v_param["registration_date"] = $old_user_mst["registration_date"];
	$v_param["entry_date"] = $old_user_mst["entry_date"];
	$v_param["login_date"] = $old_user_mst["login_date"];
	$v_param["withdrawn_date"] = $old_user_mst["withdrawn_date"];
	$v_param["login"] = $old_user_mst["login"];
	$v_param["pass"] = $old_user_mst["pass"];
	$v_param["open_id"] = null;
	$v_param["fp_serial"] = $old_user_mst["serial_code"];
	$v_param["guid"] = $v_param["fp_serial"];
	$v_param["sp_mail"] = null;
	$v_param["fp_mail"] = $old_user_mst["mail"];
	$v_param["os"] = Os::FEATURE;
	$v_param["carrier"] = $old_user_mst["carrier"];
	$v_param["status"] = $old_user_mst["status"];
	$v_param["magazine_status"] = $old_user_mst["magazine_status"];
	$v_param["birthday"] = $old_user_mst["birthday"];
	$v_param["birth_time"] = $old_user_mst["birth_time"];
	$v_param["blood"] = $old_user_mst["blood"];
	$v_param["area"] = $old_user_mst["area"];
	$v_param["city"] = convertCoding($old_user_mst["city"]);
	$v_param["birth_place"] = convertCoding($old_user_mst["birth_place"]);
	$v_param["birth_place_detail"] = convertCoding($old_user_mst["birth_place_detail"]);
	$v_param["marriage"] = convertCoding($old_user_mst["marriage"]);
	$v_param["job"] = convertCoding($old_user_mst["job"]);
	$v_param["interest"] = convertCoding($old_user_mst["interest"]);
	$v_param["sex"] = $old_user_mst["sex"];
	$v_param["introducer_login"] = $old_user_mst["introducer_login"];
	$v_param["nickname"] = convertCoding($old_user_mst["nickname"]);
	$v_param["cpno"] = $old_user_mst["cpno"];
	$v_param["afid"] = $old_user_mst["afid"];
	$v_param["seo_keyword"] = null;
	$v_param["fp_course_array"] = convertCourseCode($old_user_mst["official_course"]);
	$v_param["sp_course_array"] = null;
	$v_param["personality_no"] = $old_user_mst["personality_no"];
	// このままで、DBに保存、IDも保持
	$result = $db->doInsertAndReturn($new_table_name, $v_param);
}


// lovemi.jpのofficial_regist_datをregist_course_log_datにコピー
$old_table_name = "official_regist_dat";
$new_table_name = "regist_course_log_dat";
$old_official_regist_list = $tmp_array[$old_table_name];
$used_registed_user_id_array = array();
$used_withdraw_user_id_array = array();
foreach ($old_official_regist_list as $old_official_regist_dat) {
	$user_mst = UserMst::getById($old_official_regist_dat["user_id"]);
	if ($user_mst == null) {
		// UserMstがなくなったら、無視
		continue;
	}

	$v_param = array();
	$v_param["id"] = $old_official_regist_dat["id"];
	$v_param["registration_date"] = $old_official_regist_dat["registration_date"];
	$v_param["view_name"] = "FP";
	$v_param["os"] = Os::FEATURE;
	$v_param["carrier"] = $user_mst->carrier;
	$v_param["course_code"] = convertCourseCode($old_official_regist_dat["course_id"]);
	$v_param["user_id"] = $user_mst->id;
	$v_param["status"] = "NEW"; // 全部です。
	if (!in_array($user_mst->id, $used_registed_user_id_array)) {
		$v_param["is_regist"] = true;
		array_push($used_registed_user_id_array, $user_mst->id);
	}
	if (!empty($old_official_regist_dat["withdraw_date"])) {
		if (!in_array($user_mst->id, $used_withdraw_user_id_array)) {
			$v_param["is_withdraw"] = true;
			array_push($used_withdraw_user_id_array, $user_mst->id);
		}
	}
	$v_param["is_reregist_this_month"] = false; // 利用しない
	$v_param["is_reregist_past_month"] = false; // 利用しない
	$v_param["entry_date"] = $v_param["registration_date"];
	$v_param["withdraw_date"] = $old_official_regist_dat["withdraw_date"];
	$v_param["price"] = 0; // 利用しない
	$v_param["cpno"] = $user_mst->cpno;
	if (empty($v_param["cpno"])) {
		if (!empty($user_mst->introducer_login)) {
			$v_param["cpno"] = "INTRODUCE";
		} else {
			$v_param["cpno"] = "NONE";
		}
	}
	$v_param["afid"] = $user_mst->afid;
	$v_param["introducer_login"] = $user_mst->introducer_login;
	$result = $db->doInsertAndReturn($new_table_name, $v_param);
}


// lovemi.jpのofficial_point_datをuser_point_datにコピー
$old_table_name = "official_point_dat";
$new_table_name = "user_point_dat";
$old_official_point_list = $tmp_array[$old_table_name];
foreach ($old_official_point_list as $old_official_point_dat) {
	$v_param = array();
	$v_param["id"] = $old_official_point_dat["id"];
	$v_param["registration_date"] = $old_official_point_dat["registration_date"];
	$v_param["user_id"] = $old_official_point_dat["user_id"];
	$v_param["point_type"] = "P1";
	$v_param["limit_date"] = $old_official_point_dat["limit_date"];
	$v_param["category"] = $old_official_point_dat["category"];
	$v_param["point"] = $old_official_point_dat["point"];
	$v_param["original_point"] = $old_official_point_dat["original_point"];
	$result = $db->doInsertAndReturn($new_table_name, $v_param);
}


// lovemi.jpのcampaign_total_datをcampaign_total_datにコピー
$old_table_name = "campaign_total_dat";
$new_table_name = "campaign_total_dat";
$old_campaign_total_list = $tmp_array[$old_table_name];
foreach ($old_campaign_total_list as $old_campaign_total_dat) {
	$v_param = array();
	$v_param["id"] = $old_campaign_total_dat["id"];
	$v_param["registration_date"] = $old_campaign_total_dat["registration_date"];
	$v_param["target_date"] = $old_campaign_total_dat["target_date"];
	$v_param["cpno"] = $old_campaign_total_dat["cpno"];
	$v_param["view_name"] = "FP";
	$v_param["os"] = Os::FEATURE;
	$v_param["carrier"] = $old_campaign_total_dat["carrier"];
	
	$view_count = 0;
	$regist_count = 0;
	$withdraw_count = 0;
	
	for ($i = 0; $i < 24; $i ++) {
		$v_param["view_count_" . $i] = $old_campaign_total_dat["view_count_" . $i];
		$v_param["regist_count_" . $i] = $old_campaign_total_dat["regist_count_" . $i];
		$v_param["withdraw_count_" . $i] = $old_campaign_total_dat["withdraw_count_" . $i];
		
		$view_count += $old_campaign_total_dat["view_count_" . $i];
		$regist_count += $old_campaign_total_dat["regist_count_" . $i];
		$withdraw_count += $old_campaign_total_dat["withdraw_count_" . $i];
	}
	$v_param["view_count"] = $view_count;
	$v_param["extra_count"] = 0;
	$v_param["regist_count"] = $regist_count;
	$v_param["withdraw_count"] = $withdraw_count;
	$v_param["reregist_past_month_count"] = 0;
	$v_param["reregist_this_month_count"] = 0;
	$v_param["withdraw_force_count"] = 0;
	$result = $db->doInsertAndReturn($new_table_name, $v_param);
}


// lovemi.jpのlifetime_log_datをlifetime_total_datにコピー
$old_table_name = "lifetime_log_dat";
$new_table_name = "lifetime_total_dat";
$old_lifetime_log_list = $tmp_array[$old_table_name];
foreach ($old_lifetime_log_list as $old_lifetime_log_dat) {
	$v_param = array();
	$v_param["id"] = $old_lifetime_log_dat["id"];
	$v_param["registration_date"] = $old_lifetime_log_dat["registration_date"];
	$v_param["target_month"] = $old_lifetime_log_dat["target_month"];
	$v_param["cpno"] = $old_lifetime_log_dat["cpno"];
	$v_param["view_name"] = "FP";
	$v_param["carrier"] = $old_lifetime_log_dat["carrier"];
	$v_param["entry_month"] = $old_lifetime_log_dat["entry_month"];
	$v_param["regist_count"] = $old_lifetime_log_dat["regist_count"];
	$v_param["withdraw_count"] = $old_lifetime_log_dat["withdraw_count"];
	$result = $db->doInsertAndReturn($new_table_name, $v_param);
}


//*/
// regist_course_log_datからregist_course_total_day_datに集計
$sql = "select date_trunc('day', registration_date) as target_date, count(*) as count, sum(price) as price, cpno, view_name, carrier, course_code, status from regist_course_log_dat where delete_flg=false group by cpno, view_name, carrier, course_code, status, date_trunc('day', registration_date)";
$result = $db->executeQuery($sql);
foreach ($result as $tmp) {
	$regist_course_total_day_dat = new RegistCourseTotalDayDat();
	$regist_course_total_day_dat->target_day = $tmp["target_date"];
	$regist_course_total_day_dat->cpno = $tmp["cpno"];
	$regist_course_total_day_dat->view_name = $tmp["view_name"];
	$regist_course_total_day_dat->carrier = $tmp["carrier"];
	$regist_course_total_day_dat->course_code = $tmp["course_code"];
	$regist_course_total_day_dat->status = $tmp["status"];
	$regist_course_total_day_dat->price = $tmp["price"];
	$regist_course_total_day_dat->count = $tmp["count"];
	$regist_course_total_day_dat->save();
}


// Fixseq (user_mst,regist_course_log_dat,user_point_dat,campaign_total_dat,lifetime_total_dat,regist_course_total_day_dat)
$sql = <<<SQL
update user_mst set status='WITHDRAW' where delete_flg=false and status='MEMBER' and fp_course_array = '';
select setval('user_mst_id_seq', (select max(id) from user_mst));
select setval('regist_course_log_dat_id_seq', (select max(id) from regist_course_log_dat));
select setval('user_point_dat_id_seq', (select max(id) from user_point_dat));
select setval('campaign_total_dat_id_seq', (select max(id) from campaign_total_dat));
select setval('lifetime_total_dat_id_seq', (select max(id) from lifetime_total_dat));
select setval('regist_course_total_day_dat_id_seq', (select max(id) from regist_course_total_day_dat));
SQL;
$db->executeQuery($sql);


/**
 * CourseCodeにConvert
 */
function convertCourseCode($course_id_array) {
	global $monthly_course_array;
	//TODO
	$course_code_array = array();
	
	if ($course_id_array == "DEFAULT" || $course_id_array == "") {
		// Nullを戻す
	} else {
		$tmp_array = explode(",", $course_id_array);
		foreach ($tmp_array as $course_id) {
			array_push($course_code_array, $monthly_course_array[$course_id][1]);
		}
	}
	
	return implode(",", $course_code_array);
}

/**
 * Encoding Convert
 */
function convertCoding($string) {
	return mb_convert_encoding($string, "utf-8", "shift-jis");
}
?>
$nickname = preg_replace("/##(\w+)##/", $this->context->emoji("\\1"), $nickname);

$emoji = NetaplaEmojiHandler::getEmojiDefInstance();
$emoji->convert($html, Carrier::OTHER, EMOJI_CODE, $this->browser, EMOJI_SJISRAW);

$url = "http://" . HOST_NAME . "/member/link_delete_result.html";
$url = $this->tag_action->createLinkUrl($url);
$tag_html = $this->tag_action->getFormStartTag($url);
$tag_html .= $this->tag_action->createHiddenHtml("link_id", $link_id) . "\n";

$url = "http://" . HOST_NAME . "/member/link_list.html?category=" . $category;
$link_html = $this->tag_action->createLinkUrl($url);
$this->context->setLinkTag("link_list.url", $link_html, "外部リンク一覧のURL");

$this->context->setSystemTag("realbbs.delete.result.body", $body, "削除完了画面の本文");

$this->logic_mode == LogicMode::PREVIEW
$this->debug_mode变换成$this->logic_mode == LogicMode::MANAGER
	
$action = new FsNmoriReplyMailAction();
$mail_type = MailType::getByName("realbbs_upload_header_start");


$browser = $this->tag_action->getBrowser();
$mail_type = MailType::getByName("realbbs_upload_header_start");
$action = new FsNmoriSendMailAction($browser);
$action->initWithMailType($this->user, $mail_type);
$action->logic->setLogicMode(LogicMode::NORMAL);
$template = $action->logic->getMailTemplateMst();
$action->execute();

$info = BrowserHandler::getCachedBrowserInfo();
$browser = $info->getBrowserFromEnv();
$mail_type = MailType::getByName("fp_reconfirm_error");
$action = new FsNmoriSendMailAction($browser);
$action->initWithMailType($user_mst, $mail_type);
$action->logic->setLogicMode(LogicMode::NORMAL);
$action->execute();



//$html = $action->getMailtoHtml();
$to_addrs = REAL_HEADER_IMAGE_ADDRESS;

while(! @feof($get_str_resorce)){
	$get_str .= @fread($get_str_resorce, 1024);
}
fp_article_comment_history

http://fsnmori.youmail.jp/member/article_view_history_user.html  setOwnerTag

http://fsnmori.youmail.jp/gekiatsu/gekiatsu_top.html

$mail_type = MailType::getByName($page_name);
$action = new FsNmoriReplyMailAction();
$action->initWithMailTypeAndFromAddress($mail_type, $to_address);
$action->logic->url = $tmp_url;
$action->logic->setUser($user_mst);
$action->logic->setLogicMode(LogicMode::NORMAL);
try {
	$action->execute();
} catch (MailDoneException $e) {
	ErrorLogger::doOutput($page_name . " send!");
}

-----------------------------------------
netapla_mypage_design_dat; 0
netapla_accuse_dat; 	0
netapla_realtime_bbs_mst;  0

---------------------------------------------

netapla_article_vote_dat; 633657
netapla_article_view_dat;  963830
netapla_article_access_log_dat; 2991497
netapla_article_comment_dat; 93134
netapla_article_search_text_dat; 4553
netapla_black_list_dat; 263
netapla_footprint_dat; 368174
netapla_image_dat;  30953
netapla_wiki_keyword_dat; 2249
gekiatsu_vote_dat;  277
netapla_mypage_dat; 6125
netapla_realtime_bbs_dat;  18212
netapla_enquete_bbs_mst; 53037
netapla_enquete_bbs_vote_dat;  52737
netapla_article_comment_log_dat;  45876
netapla_enquete_bbs_comment_dat;  411550
netapla_article_search_log_dat; 13597452
netapla_user_point_dat;  929272
netapla_article_genre_dat; 34206
netapla_article_mst; 20243
netapla_article_tag_dat; 63390
netapla_point_setting_dat; 4
netapla_link_dat; 1343
netapla_ngword_dat; 868
netapla_okdomain_dat;  3
netapla_ngdomain_dat;  3
netapla_site_mst;  7
netapla_site_banner_rotate_mst; 4
netapla_site_banner_rotate_dat; 28
netapla_article_genre_mst; 35

以上全部
-------------------------------------------

netapla_wiki_keyword_dat
netapla_mypage_dat
netapla_link_dat
netapla_ngword_dat

netapla_article_search_text_dat
netapla_black_list_dat
gekiatsu_vote_dat
netapla_point_setting_dat
netapla_okdomain_dat
netapla_ngdomain_dat
netapla_site_mst
netapla_site_banner_rotate_mst
netapla_site_banner_rotate_dat
netapla_article_genre_mst
以上小刘采用老王方法

----------------------------------
netapla_article_vote_dat; 633657 √
netapla_article_view_dat;  963830  √ 
netapla_article_access_log_dat; 2991497 √
netapla_article_comment_dat; 93134 √
netapla_footprint_dat; 368174
netapla_image_dat;  30953
netapla_realtime_bbs_dat;  18212
netapla_enquete_bbs_mst; 53037
netapla_enquete_bbs_vote_dat;  52737
netapla_article_comment_log_dat;  45876
netapla_enquete_bbs_comment_dat;  411550
netapla_article_search_log_dat; 13597452
netapla_user_point_dat;  929272
netapla_article_genre_dat; 34206
netapla_article_mst; 20243
netapla_article_tag_dat; 63390


---------------------------------


----------------------------------
----------------------------------
netapla_article_vote_dat; 633657 √
netapla_article_view_dat;  963830  √ 
netapla_article_access_log_dat; 2991497 √
netapla_article_comment_dat; 93134 √
netapla_footprint_dat; 368174 √
netapla_image_dat;  30953
netapla_realtime_bbs_dat;  18212 √
netapla_enquete_bbs_mst; 53037
netapla_enquete_bbs_vote_dat;  52737
netapla_article_comment_log_dat;  45876
netapla_enquete_bbs_comment_dat;  411550
netapla_article_search_log_dat; 13597452
netapla_user_point_dat;  929272
netapla_article_genre_dat; 34206
netapla_article_mst; 20243 √
netapla_article_tag_dat; 63390
----------------------------------
---------------------------------


----------------------------------
----------------------------------
----------------------------------
----------------------------------
netapla_article_vote_dat; 633657 √
netapla_article_view_dat;  963830  √ 
netapla_article_access_log_dat; 2991497 √
netapla_article_comment_dat; 93134 √
netapla_footprint_dat; 368174 √
netapla_image_dat;  30953 √
netapla_realtime_bbs_dat;  18212 √
netapla_enquete_bbs_mst; 53037 √
netapla_enquete_bbs_vote_dat;  52737
netapla_article_comment_log_dat;  45876
netapla_enquete_bbs_comment_dat;  411550
netapla_article_search_log_dat; 13597452
netapla_user_point_dat;  929272
netapla_article_genre_dat; 34206
netapla_article_mst; 20243 √
netapla_article_tag_dat; 63390
----------------------------------

-----------------------------------
-----------------------------------
netapla_article_vote_dat; 633657 √
netapla_article_view_dat;  963830  √ 
netapla_article_access_log_dat; 2991497 √
netapla_article_comment_dat; 93134 √
netapla_footprint_dat; 368174 √
netapla_image_dat;  30953 √
netapla_realtime_bbs_dat;  18212 √
netapla_enquete_bbs_mst; 53037 √
netapla_enquete_bbs_vote_dat;  52737 √
netapla_article_comment_log_dat;  45876√

netapla_article_genre_dat; 34206√
netapla_article_mst; 20243 √
netapla_article_tag_dat; 63390	√
-------------------------
-------------------------


--------------------
--------------------
netapla_enquete_bbs_comment_dat;  411550 √
netapla_article_search_log_dat;   13597452 √
netapla_user_point_dat;			  929272  √
banner_total_dat				  1256292 √
banner_group_mst				  70
banner_mst						  3981
banner_rotate_mst				  121
banner_rotate_dat				  4832
------------------
------------------
pg_dump -c --column-inserts -t aaa > aaa.sql 

pg_dump -h 10.17.3.192 -t netapla_enquete_bbs_comment_dat > backup.sql

scp /home/nmori/backup2.sql fsnmori@49.212.21.74:~
psql < backup2.sql

truncate table netapla_enquete_bbs_comment_dat;
select setval('netapla_enquete_bbs_comment_dat_id_seq', 1, false);

-----------------------------------------------------------------
netapla_article_vote_dat
netapla_article_view_dat
netapla_article_access_log_dat 
netapla_article_search_log_dat √
netapla_user_point_dat
pg_dump
---------------------------------------------------------------
pg_dump --data-only -x --table=netapla_user_point_dat nmori > nmori_20120817_netapla_user_point_dat.sql

//find_keyword($dir_name, $key_word);

//$dd = file_get_contents("dd.txt");
////$dd = mb_convert_encoding($dd, "Shift_JIS");
//
//$dd = mb_convert_encoding($dd, "UTF-8", "ms932,SHIFT_JIS,EUC-JP, sjis-win, UTF-8");		
//echo $dd;

//pg_dump -a -E SHIFT_JIS --column-inserts -t netapla_site_mst > netapla_site_mst.sql
//pg_dump -h 10.17.3.192 -a -t netapla_article_search_log_dat > netapla_article_search_log_dat.sql
//
//scp netapla_article_search_log_dat.sql fsnmori@49.212.21.74:~
//
//truncate table netapla_article_search_log_dat;
//select setval('netapla_article_search_log_dat_id_seq', 1, false);
//
//pg_dump -h 10.17.3.192  -a -x -t netapla_site_mst > netapla_site_mst.sql
//
// tar czvf images.tar.gz images

tar czvf contents_20120829.tar.gz contents
//
// tar zxvf  images.tar.gz
//
// scp /home/nmori/contents/data/images.tar.gz fsnmori@49.212.21.74:~/contents/data/
$str = "99_l.jpg";
echo preg_replace("/_(\w)/", "_s",  $str);

pg_dump -h 10.17.3.192 -c --column-inserts -t image_group_mst > image_group_mst.sql

pg_dump -h 10.17.3.192 -t banner_rotate_dat -t banner_rotate_mst -t banner_mst -t banner_group_mst > backup.sql

rm -rf /home/fsnmori/contents/user/public_html/thumbs/1/*
rm -rf /home/fsnmori/contents/user/public_html/thumbs/2/*
rm -rf /home/fsnmori/contents/user/public_html/thumbs/3/*
rm -rf /home/fsnmori/contents/user/public_html/thumbs/4/*
rm -rf /home/fsnmori/contents/user/public_html/thumbs/5/*
rm -rf /home/fsnmori/contents/user/public_html/thumbs/6/*
rm -rf /home/fsnmori/contents/user/public_html/thumbs/7/*
rm -rf /home/fsnmori/contents/user/public_html/thumbs/8/*
rm -rf /home/fsnmori/contents/user/public_html/thumbs/9/*
rm -rf /home/fsnmori/contents/user/public_html/thumbs/0/*
update banner_mst set carrier_array=replace(carrier_array, 'fpfate', 'fate');

$defintion_affiliate_logic[] = array('name'=>'Fp_POCKETAFFILIATE', 'title'=>'ポケットアフィリエイト(FP用 )', 'view'=>'FP', 'logic_name'=>'fp.FpAffiliatePocketaffiliateAffiliateLogic', 'is_notice_site'=>true,'option_mapping'=>array('param_1'=>'item_id'));
$defintion_affiliate_logic[] = array('name'=>'Sp_POCKETAFFILIATE', 'title'=>'ポケットアフィリエイト(SP用 )', 'view'=>'SP', 'logic_name'=>'sp.SpAffiliatePocketaffiliateAffiliateLogic', 'is_notice_site'=>true,'option_mapping'=>array('param_1'=>'item_id'));
1.  fp sp 测试。
2.管理側、topmenuの方、FP・SPのボタンを追加、FP/SP切り替えできる、という機能を実装。
3. fsnmori_mail.phpを経由して、
プロフィール画像変更、
リアルタイム掲示板画像変更、
リアルタイム掲示板ヘッダ部画像変更、
などの機能は正常動作かどうか、を確認
http://manager.fsnmori.youmail.jp/mail_template_list.php
↑の画面、FP・SP切り替えように改修お願いします。

\default\wikipedia_search_result.html
\gekiatsu_old\gekiatsu_shutuensha.html

如果发现log中有insert, update语句,
[19:10:30] 葛海波: 但是包含feature的字符,
[19:10:35] 葛海波: 那多半就有问题了.
[19:10:46] 葛海波: feature是fp的os
[19:11:09] 葛海波: sp的话,os应该是iphone,android等.


tar czvf images.tar.gz /home/nmori/contents/data/images
scp /home/nmori/contents/data/images.tar.gz fsnmori@ip:~/contents/data/
进入~/contents/data/ 执行 tar zxvf  images.tar.gz

ALTER TABLE netapla_article_search_log_dat drop column view_name;
ALTER TABLE netapla_article_search_log_dat drop column os;

ALTER TABLE netapla_article_search_log_dat ADD COLUMN view_name varchar(32) NOT NULL DEFAULT 'FP' ;
ALTER TABLE netapla_article_search_log_dat ADD COLUMN os varchar(16) NOT NULL DEFAULT 'OTHER' ;
sv120.ai-ms.co.jp1080 name :hongrui


insert into netapla_article_search_log_dat(id, registration_date, search_text, view_name, os, carrier, user_id, serial_code, note, delete_flg) values(5035, NULL, 'EXILE', 'FP', 'FEATURE', 'VODAFONE', 0, '', '', false);

select count(*) from netapla_article_search_log_dat;
select count(*) from netapla_site_banner_rotate_mst;
select count(*) from netapla_site_banner_rotate_dat;
select count(*) from netapla_image_dat;
select count(*) from netapla_footprint_dat;
select count(*) from netapla_realtime_bbs_dat;
select count(*) from netapla_enquete_bbs_mst;
select count(*) from netapla_enquete_bbs_vote_dat;
select count(*) from netapla_enquete_bbs_comment_dat;
select count(*) from netapla_article_comment_log_dat; 
select count(*) from netapla_user_point_dat; 
select count(*) from banner_group_mst; 
select count(*) from banner_mst; 
select count(*) from banner_rotate_mst; 
select count(*) from banner_rotate_dat; 

chmod 755 /home/fsnmori
mkdir /home/fsnmori/logs
touch /home/fsnmori/logs/php_error.log
chmod 777 /home/fsnmori/logs/php_error.log

scp /home/nmori/contents/images fsnmori@10.17.3.2:~/contents/user/public_html

INSERT INTO image_mst (name, view_name, group_name, title, alt, comment, account_id, registration_date) VALUES ('sp_withdraw_result_member', 'SP', 'for_Page', 'dd', 'dd', null, '0', '2012-09-07 23:46:08')
tar cvzf images.tar.gz images

scp /home/nmori/contents/data/images.tar.gz fsnmori@10.17.3.2:~/contents/data/images.tar.gz

tar xvzf images.tar.gz	tar xvzf images.tar.gz


sv127_10.17.3.192(app db)
sv128_10.17.3.2(app web1)
sv129_10.17.3.3(app web2)
sv130_10.17.3.4(app web3)
sv131_10.17.3.5(app web4)
sv132_10.17.3.6(app web5)

tail -f backup0815/temp_php_error1.log | grep -Ei 'error|notice'
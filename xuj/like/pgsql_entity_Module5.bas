Sub create_Entity()

		Dim sheetCount As Integer
		Dim x As Integer
		Dim y As Integer
		Dim fileName As String
		Dim targetSheet As Worksheet
		Dim tableName As String
		Dim className As String
		Dim str() As String
		Dim i As Integer
		
		Dim fs
		Set fs = CreateObject("Scripting.FileSystemObject")
		
		authorName = InputBox("作者名：")
		projectName = InputBox("項目名：")
		
		sheetCount = 1
		Do While sheetCount <= ActiveWorkbook.Worksheets.count
		
		className = ""
		
		Set targetSheet = ActiveWorkbook.Worksheets(sheetCount)
		
		If targetSheet.Name <> "表紙" And targetSheet.Name <> "更新履歴" Then
		
		str = Split(targetSheet.Name, "_")
		
		For Each strName In str
			className = className + StrConv(strName, vbProperCase)
		Next
		
		'同じファイル名のテキストファイル作成
		fileName = fs.GetParentFolderName(ActiveWorkbook.FullName) & "\" & className & ".inc"
		
		Set fp = fs.CreateTextFile(fileName, True)
		
				targetSheet.Activate
				With targetSheet
						fp.writeline ("<?php")
						fp.writeline ("/**")
						fp.writeline (" * " & className & " Entity")
						fp.writeline (" * $Id: " & className & ".inc,v 1.1 " & Now() & " Netvillage Exp $")
						fp.writeline (" * @author " & authorName)
						fp.writeline (" * @package jp." & projectName & ".entity")
						fp.writeline (" * @access public")
						fp.writeline (" */")
						fp.writeline ("")
						fp.writeline ("class " & className & " extends " & StrConv(projectName, vbProperCase) & "DynamicData {")
						fp.writeline ("")
						
						y = 14
						Do While .Cells(y, 2) <> ""
								
								If .Cells(y, 2) <> "" Then
										fp.writeline (vbTab & "public $" & .Cells(y, 2) & ";")
								End If
								
								y = y + 1
						
						Loop
						
						fp.writeline ("")
						fp.writeline (vbTab & "/**")
						fp.writeline (vbTab & " * コンストラクタ実装。" & targetSheet.Name & "からのレコードでインスタンスを生成する。")
						fp.writeline (vbTab & " * ")
						fp.writeline (vbTab & " * @access public")
						fp.writeline (vbTab & " * @param mixed " & targetSheet.Name & "からのレコード")
						fp.writeline (vbTab & " */")
						fp.writeline (vbTab & "function constructor($record) {")
						fp.writeline (vbTab & vbTab & "parent::constructor($record);")
						
						y = 14
						Do While .Cells(y, 2) <> ""
								
								If .Cells(y, 2) <> "" Then
										fp.writeline (vbTab & vbTab & "$this->" & .Cells(y, 2) & " = $record[""" & .Cells(y, 2) & """];")
								End If
								
								y = y + 1
						
						Loop
						
						fp.writeline (vbTab & "}")
						fp.writeline ("")
						fp.writeline (vbTab & "/**")
						fp.writeline (vbTab & " * 条件にしたがって、登録されているデータの一覧を取得します。")
						fp.writeline (vbTab & " * 渡すことのできる条件は、DBManagerのdoSelectと同じです。")
						fp.writeline (vbTab & " * @access public")
						fp.writeline (vbTab & " * @static")
						fp.writeline (vbTab & " * @param array 検索条件")
						fp.writeline (vbTab & " * @return array Entityの配列")
						fp.writeline (vbTab & " */")
						fp.writeline (vbTab & "public static function getList($w_param = null, $orderkey = null, $direction = ""ASC"", $offset = null, $limit = null) {")
						fp.writeline (vbTab & vbTab & "if ($w_param == null) {")
						fp.writeline (vbTab & vbTab & vbTab & "$w_param = array();")
						fp.writeline (vbTab & vbTab & vbTab & "$w_param[""delete_flg""] = ""false"";")
						fp.writeline (vbTab & vbTab & "}")
						fp.writeline (vbTab & vbTab & "return " & StrConv(projectName, vbProperCase) & "DBHandler::getList(""" & className & """, """ & targetSheet.Name & """, $w_param, $orderkey, $direction, $offset, $limit);")
						fp.writeline (vbTab & "}")
			fp.writeline ("")
						fp.writeline (vbTab & "/**")
						fp.writeline (vbTab & " * 条件にしたがって、登録されているデータの一覧の件数を取得します。")
						fp.writeline (vbTab & " * 渡すことのできる条件は、DBManagerのdoSelectと同じです。")
						fp.writeline (vbTab & " * @access public")
						fp.writeline (vbTab & " * @static")
						fp.writeline (vbTab & " * @param array 検索条件")
						fp.writeline (vbTab & " * @return array Entityの配列")
						fp.writeline (vbTab & " */")
						fp.writeline (vbTab & "public static function getListCount($w_param = null) {")
						fp.writeline (vbTab & vbTab & "if ($w_param == null) {")
						fp.writeline (vbTab & vbTab & vbTab & "$w_param = array();")
						fp.writeline (vbTab & vbTab & vbTab & "$w_param[""delete_flg""] = ""false"";")
						fp.writeline (vbTab & vbTab & "}")
			fp.writeline (vbTab & vbTab & "$db = &" & StrConv(projectName, vbProperCase) & "DBManager::getInstance();")
			fp.writeline (vbTab & vbTab & "$result = $db->doSelect(""" & targetSheet.Name & """, $w_param, null, null, null, null, ""count(*) as count"");")
						fp.writeline (vbTab & vbTab & "return $result[0][""count""];")
						fp.writeline (vbTab & "}")
						fp.writeline ("")
						fp.writeline (vbTab & "/**")
						fp.writeline (vbTab & " * 指定したIDのこのクラスのインスタンスを取得します。")
						fp.writeline (vbTab & " */")
						fp.writeline (vbTab & "public static function getById($id) {")
						fp.writeline ("")
						fp.writeline (vbTab & vbTab & "// delete_flg")
						fp.writeline (vbTab & vbTab & "$param = array();")
						fp.writeline (vbTab & vbTab & "$param[""delete_flg""] = false;")
						fp.writeline (vbTab & vbTab & "return " & StrConv(projectName, vbProperCase) & "DBHandler::getById(""" & className & """, """ & targetSheet.Name & """, $id, $param);")
						fp.writeline (vbTab & "}")
						fp.writeline ("")
						fp.writeline ("// -- ここからDynamic ---")
						fp.writeline (vbTab & "/**")
						fp.writeline (vbTab & " * このインスタンスをDBに書き込みます。")
						fp.writeline (vbTab & " * DynamicData共通の保存方法です。")
						fp.writeline (vbTab & " * @access public")
						fp.writeline (vbTab & " * @return int 書き込んだインスタンスのID")
						fp.writeline (vbTab & " */")
						fp.writeline (vbTab & "function save() {")
						fp.writeline ("")
						fp.writeline (vbTab & vbTab & "$v_param = array();")
						fp.writeline ("")
						
						y = 14
						Do While .Cells(y, 2) <> ""
								
								If .Cells(y, 2) <> "" Then
												If .Cells(y, 5) = "N" Then
										fp.writeline (vbTab & vbTab & "ParamUtil::copyObj2Array($v_param, $this, """ & .Cells(y, 2) & """);")
									 Else
										fp.writeline (vbTab & vbTab & "ParamUtil::copyObj2ArrayNullField($v_param, $this, """ & .Cells(y, 2) & """);")
									 End If
								End If
								
								y = y + 1
						
						Loop
						
						fp.writeline ("")
						fp.writeline (vbTab & vbTab & "// 保存する")
						fp.writeline (vbTab & vbTab & "parent::_save(""" & targetSheet.Name & """, $v_param);")
						fp.writeline (vbTab & "}")
						fp.writeline ("}")
						fp.write ("?>")
		
				End With
				
				'終了
				fp.Close
		
		End If
		
		sheetCount = sheetCount + 1
		
		Loop
				
		
		MsgBox "DBテンプレート作成しました"

End Sub

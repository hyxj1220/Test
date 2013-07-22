
Sub createPostgreSQLTemplate()

    Dim sheetCount As Integer
    Dim x As Integer
    Dim y As Integer
    Dim loopSafe As Integer
    '�V�[�P���X�𗘗p����E
    Dim useSequence As Boolean
    '�V�[�P���X�̑Ώۃt�B�[���h
    Dim sequenceField As String
    Dim sequenceName As String
    Dim fileName As String
    Dim targetSheet As Worksheet
    
    Debug.Print "Postgres�pDB�e���v���[�g�쐬�}�N��"
    
    '�ڕW�t�B�[���h��������Ȃ��Ƃ��A������߂�s���B
    loopSafe = 300
    
    
    Dim fs
    Set fs = CreateObject("Scripting.FileSystemObject")
    
    '�����t�@�C�����̃e�L�X�g�t�@�C����E
    fileName = fs.GetParentFolderName(ActiveWorkbook.FullName) & "\" & fs.GetBaseName(ActiveWorkbook.FullName) & ".txt"
    Debug.Print fileName
    
    If fs.FileExists(fileName) Then
        x = 1
        Do While fs.FileExists(fs.GetParentFolderName(ActiveWorkbook.FullName) & "\" & fs.GetBaseName(ActiveWorkbook.FullName) & x & ".txt")
        
            x = x + 1
        Loop
        fileName = fs.GetParentFolderName(ActiveWorkbook.FullName) & "\" & fs.GetBaseName(ActiveWorkbook.FullName) & x & ".txt"
    End If
    
    Set fp = fs.CreateTextFile(fileName, True)
  
    sheetCount = 1
    Do While sheetCount <= ActiveWorkbook.Worksheets.count
    
    
    Set targetSheet = ActiveWorkbook.Worksheets(sheetCount)
    
    
    If targetSheet.Name <> "�\��" And targetSheet.Name <> "�X�V����" And targetSheet.Name <> "title" Then
    
    
        targetSheet.Activate
        With targetSheet
            fp.WriteLine ("----" & .Cells(3, 3) & "�쐬")
            fp.WriteLine ("")
            
            
            
            '�e�[�u����E
            fp.WriteLine ("CREATE TABLE " & .Cells(3, 3) & "(")
            '�{�̕�����{�E
            y = 8
            Do While .Cells(y, 2) <> "TABLE"
                y = y + 1
                If y > loopSafe Then
                    Exit Do
                End If
            Loop
            
            '��������{�̂̓��e
            y = y + 2
            Do Until .Cells(y, 2) = ""
                Dim line As String
                '�t�B�[���h�� �^�C�v
                line = .Cells(y, 2) & " " & .Cells(y, 3)
                
                'NULL���E
                If .Cells(y, 5) = "N" Then
                    line = line & " NOT NULL"
                End If
                
                '�f�t�H���g�l�A�V�[�P���X�̎w�E
                If .Cells(y, 6) <> "" Then
                    If UCase(.Cells(y, 6)) = "TRUE" Then
                        line = line & " DEFAULT 'true'"
                    ElseIf UCase(.Cells(y, 6)) = "FALSE" Then
                        line = line & " DEFAULT 'false'"
                    ElseIf .Cells(y, 6) = "now()" Then
                        line = line & " DEFAULT now()"
                    Else
                        line = line & " DEFAULT '" & .Cells(y, 6) & "'"
                    End If
                End If
                
                'PrimaryKey�̃Z�b�g
                If .Cells(y, 4) = "P" Then
                    line = line & " PRIMARY KEY"
                End If
                
                '���̍s������Ȃ�R���}�ő����E
                If .Cells(y + 1, 2) <> "" Then
                    line = line & ","
                End If
                
                
                fp.WriteLine (vbTab & line)
                y = y + 1
                If y > loopSafe Then
                    Exit Do
                End If
            Loop
            fp.WriteLine (");")
            fp.WriteLine ("")
            
            'INDEX�̍�E
            Do While .Cells(y, 2) <> "INDEX"
                y = y + 1
                If y > loopSafe Then
                    Exit Do
                End If
            Loop
            'Debug.Print .Cells(3, 3) & "line:" & y & .Cells(y, 2)
            y = y + 2
            Do Until .Cells(y, 2) = ""
                If .Cells(y, 6) = "Y" Then
                    line = "CREATE UNIQUE INDEX " & .Cells(y, 2) & " ON " & .Cells(3, 3) & " (" & .Cells(y, 3) & ");"
                Else
                    line = "CREATE INDEX " & .Cells(y, 2) & " ON " & .Cells(3, 3) & " (" & .Cells(y, 3) & ");"
                End If
                fp.WriteLine (line)
                y = y + 1
            Loop
            fp.WriteLine ("")
            fp.WriteLine ("")
            'Debug.Print "----" & .Cells(3, 3) & "�쐬"
    
        End With
        
        
    
    End If
    
    sheetCount = sheetCount + 1
    
    Loop
    
    '�I�E
    fp.Close
   

End Sub

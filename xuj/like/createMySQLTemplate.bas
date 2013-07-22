Attribute VB_Name = "createMySQLver2"

Sub createMySQLTemplate()

    Dim sheetCount As Integer
    Dim x As Integer
    Dim y As Integer
    Dim z As Integer
    Dim m As Integer
    Dim n As Integer
    Dim indexCount As Integer
    Dim bigName As String
    Dim loopSafe As Integer
    Dim fileName As String
    Dim targetSheet As Worksheet
    
    Dim StrIndex As String
    
    Debug.Print "DB�e���v���[�g�쐬�}�N��"
    
    loopSafe = 150
    
    Dim fs
    Set fs = CreateObject("Scripting.FileSystemObject")
    
    '�����t�@�C�����̃e�L�X�g�t�@�C���쐬
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
    
    
    If targetSheet.Name <> "�\��" And targetSheet.Name <> "�X�V����" Then
    
    
        targetSheet.Activate
        With targetSheet
            ' Debug.Print .Cells(3, 3)
            fp.WriteLine ("----" & .Cells(3, 3) & "�쐬")
            fp.WriteLine ("")
            
            
            '�e�[�u���쐬
            fp.WriteLine ("CREATE TABLE " & .Cells(3, 3) & "(")
            '�{�̕�����{��
            y = 8
            Do While .Cells(y, 2) <> "TABLE"
                y = y + 1
                If y > loopSafe Then
                    Exit Do
                End If
            Loop
            
            z = 10
            'bigint�̎擾
            Do While .Cells(z, 2) <> "SEQUENCE"
                z = z + 1
                If z > loopSafe Then
                    Exit Do
                End If
            Loop
            
            z = z + 2
            Do Until .Cells(z, 2) = ""
                If .Cells(z, 8) = "9223372036854770000" Then
                    bigName = .Cells(z, 3)
                Else
                    bigName = ""
                End If
                
                z = z + 1
                If z > loopSafe Then
                    Exit Do
                End If
            Loop
            'bigint�̎擾--------END
            
            'INDEX�̍쐬
            n = 10
            Do While .Cells(n, 2) <> "INDEX"
                n = n + 1
                If n > loopSafe Then
                    Exit Do
                End If
            Loop
            
            indexCount = 1
            If .Cells(n + 2, 2) = "" Then
                indexCount = 0
            End If
            
            '��������{�̂̓��e
            y = y + 2
            Do Until .Cells(y, 2) = ""
                Dim line As String
                '�t�B�[���h�� �^�C�v
                If UCase(.Cells(y, 2)) = "ID" Then
                    If UCase(.Cells(y, 2)) = UCase(bigName) Then
                        line = .Cells(y, 2) & " bigint" & " unsigned"
                    Else
                        line = .Cells(y, 2) & " " & .Cells(y, 3) & " unsigned"
                    End If
                Else
                    If UCase(.Cells(y, 2)) = UCase(bigName) Then
                        line = .Cells(y, 2) & " bigint"
                    Else
                        If UCase(.Cells(y, 3)) = "BOOLEAN" Then
                            line = .Cells(y, 2) & " tinyint(1)"
                        Else
                            line = .Cells(y, 2) & " " & .Cells(y, 3)
                        End If
                    End If
                End If
                
                'NULL����
                If .Cells(y, 5) = "N" Then
                    line = line & " NOT NULL"
                End If
                
                '�f�t�H���g�l�A�V�[�P���X�̎w��
                If .Cells(y, 6) <> "" And UCase(.Cells(y, 2)) <> "REGISTRATION_DATE" Then
                    If UCase(.Cells(y, 6)) = "TRUE" Then
                        line = line & " DEFAULT '1'"
                    ElseIf UCase(.Cells(y, 6)) = "FALSE" Then
                        line = line & " DEFAULT '0'"
                    ElseIf .Cells(y, 6) = "now()" Then
                        line = line & " DEFAULT now()"
                    Else
                        line = line & " DEFAULT '" & .Cells(y, 6) & "'"
                    End If
                End If
                
                'PrimaryKey�̃Z�b�g
                'TODO P�����Ă�����APrimary key�ł͂��邪�Aauto_increment�̓V�[�P���X�Ŏw�肳�ꂽ�t�B�[���h�ɂ���B
                'TODO ���l�ɁAauto_increment�̃t�B�[���h�͂P�Ƃ͌���Ȃ��B
                If .Cells(y, 4) = "P" Then
                    line = line & " PRIMARY KEY auto_increment"
                End If
                
                '���̍s������Ȃ�R���}�ő�����
                line = line & ","
                If .Cells(y + 1, 2) = "" Then
                    line = Left(line, Len(line) - 1)
                End If
                
                fp.WriteLine (vbTab & line)
                y = y + 1
                If y > loopSafe Then
                    Exit Do
                End If
            Loop
            
            'INDEX�̍쐬
            Do While .Cells(y, 2) <> "INDEX"
                y = y + 1
                If y > loopSafe Then
                    Exit Do
                End If
            Loop
            
            y = y + 2
            Do While .Cells(y, 2) <> ""
                m = 10
                Do While .Cells(m, 2) <> ""
                    If .Cells(m, 2) = .Cells(y, 3) Then
                        'TEXT�^�ɂ́A������255��INDEX������
                        If UCase(.Cells(m, 3)) = "TEXT" Then
                            If .Cells(y, 6) = "Y" Then
                                line = vbTab & "UNIQUE (" & .Cells(y, 3) & "(255))"
                            Else
                                StrIndex = StrIndex & "Create INDEX " & .Cells(y, 2) & " ON " & .Cells(3, 3) & "(" & .Cells(y, 3) & "(255));" & vbCrLf
                            End If
                        Else
                            If .Cells(y, 6) = "Y" Then
                                line = vbTab & "UNIQUE (" & .Cells(y, 3) & ")"
                            Else
                                StrIndex = StrIndex & "Create INDEX " & .Cells(y, 2) & " ON " & .Cells(3, 3) & "(" & .Cells(y, 3) & ");" & vbCrLf
                            End If
                        End If
                        Exit Do
                    End If
                    
                    m = m + 1
                    If m > loopSafe Then
                        Exit Do
                    End If
                Loop
                
                '���̍s������Ȃ�R���}�ő�����
                If .Cells(y + 1, 2) <> "" Then
                    'line = line & ","
                End If
                'fp.WriteLine (line)
                
                y = y + 1
                If y > loopSafe Then
                    Exit Do
                End If
            Loop
            fp.WriteLine (") TYPE = INNODB;")
            fp.WriteLine ("")
            fp.WriteLine (StrIndex)
            fp.WriteLine ("")
    
        End With
    
    End If
    
    sheetCount = sheetCount + 1
    
    StrIndex = ""
    
    Loop
    
    '�I��
    fp.Close

End Sub

main_cir: dialog {
label = "���������� �����������";
:boxed_column {
	label = "������ ������";
	:row {
	:text { label = "�������� �����(�) ������"; }
	:button {
		key = "obj_take";
		label = "�������";
		action = "(done_dialog 10)";
		fixed_width = true;
	}//button
	}//row
	:row {
	:edit_box {
		label = "������� ������� ����, ��";
		key = "diam_take";
		edit_width = 10;
		edit_limit = 10;
		value = "";
	 }//edit_box
	 }//row
}//boxed_row

:boxed_row {
	label = "���� � ���� ��� ����������";
	children_alignment = centered;
	:popup_list {
		label = "���� ";
		key = "layer_take";
		list = "";
		width = 25;
	}//popup_list
	:edit_box {
		key = "layer_name";
		edit_width = 12;
		edit_limit = 20;
	}//edit box
	:image_button {
		key = "colortake";
		width = 4;
		fixed_width = true;
	}//image_button	
}//boxed_row
:row {
	children_alignment = centered; 
	:row {
		children_alignment = centered;
		:column {
			children_alignment = centered;
			:button {
				key = "build";
				label = "  ���������  ";
				action = "(done_dialog 9)";
				height = 5;
				fixed_width = true;
			}//button		
		}//column
	}//row
	:boxed_radio_column {
	label = "������ ����������";
	:radio_button {label = "�� ���� ������"; key = "cir1"; value = "1";}
	:radio_button {label = "�� ������� �������"; key = "cir2"; value = "0";}
	}//boxed_
}//row
ok_cancel_help;
}//main_ci


//������ �������
help_cir: dialog {
label = "�������";
:boxed_column {
label = "������������������ �����������";
:text {label = "��� 1 �������� �����(�) ������";}
:text {label = "��� 2 ������ ������� � ��";}
:text {label = "��� 3 ������� ���� � ���� ��� ����������";}
:text {label = "��� 4 ������ ����� \"���������\" ��� \"��\"";}
spacer_1;
:text {label = "\"��\" - ���������� � ������� �� �������";}
:text {label = "\"���������\" - ���������� � ��������� � ������";}
spacer_1;
:text {label = "\"�� ���� ������\" - ���������� �� ���� ������ ������";}
:text {label = "������� ���� ������� ������� �� ��������� �������� ����� ����";}
:text {label = "���������� �� ������ ���������";}
spacer_1;
:text {label = "\"�� ������� �������\" - ���������� �� ������� �������";}
:text {label = "������� ������������ �� ��������� ����� ������ ����� ����";}
:text {label = "���������� ����� ���������, �������� ��������";}
spacer_1;
:text {label = "\"����������� ������ �����\" - ��� ������ ��������";}
:text {label = "��� ������ ���� ������ ����� ������ ��� ��������� ��������";}
spacer_1;
:text {label = "����������: ��� �� ����������� ���������� ��� ������������";}
:text {label = "������������ ������� � ������� \"�����\" ��������� ����� �� ��������";}
}//boxed_column
:boxed_row {
label = "����������� ������ �����";
:slider {
key = "slid_val";
big_increment = 1;
small_increment = 1;
min_value = 102;
max_value = 117;
}//slider
:text {label = "k=";}
:text {key = "Show_slide_val";}
}//boxed_row
:column {
children_alignment = centered;
:text {label = "����� ������ ���������, 2019�.";}
:text {label = "aleksandr-glushko@bk.ru";}
}//column
:ok_button{label = "��������";}
}//dialog
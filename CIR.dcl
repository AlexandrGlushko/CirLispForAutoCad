main_cir: dialog {
label = "Построение окружностей";
:boxed_column {
	label = "Данные съёмки";
	:row {
	:text { label = "Выбирите точку(и) съемки"; }
	:button {
		key = "obj_take";
		label = "Выбрать";
		action = "(done_dialog 10)";
		fixed_width = true;
	}//button
	}//row
	:row {
	:edit_box {
		label = "Введите диаметр свай, мм";
		key = "diam_take";
		edit_width = 10;
		edit_limit = 10;
		value = "";
	 }//edit_box
	 }//row
}//boxed_row

:boxed_row {
	label = "Слой и цвет для построения";
	children_alignment = centered;
	:popup_list {
		label = "Слой ";
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
				label = "  Построить  ";
				action = "(done_dialog 9)";
				height = 5;
				fixed_width = true;
			}//button		
		}//column
	}//row
	:boxed_radio_column {
	label = "Способ построения";
	:radio_button {label = "По трем точкам"; key = "cir1"; value = "1";}
	:radio_button {label = "По лучшему радиусу"; key = "cir2"; value = "0";}
	}//boxed_
}//row
ok_cancel_help;
}//main_ci


//Диалог справки
help_cir: dialog {
label = "Справка";
:boxed_column {
label = "Последовательность постороения";
:text {label = "Шаг 1 Выбирать точку(и) съёмки";}
:text {label = "Шаг 2 Ввести диаметр в мм";}
:text {label = "Шаг 3 Выбрать слой и цвет для построения";}
:text {label = "Шаг 4 Нажать кнопу \"Построить\" или \"ОК\"";}
spacer_1;
:text {label = "\"ОК\" - построение с выходом из диалога";}
:text {label = "\"Построить\" - построение с возвратом в диалог";}
spacer_1;
:text {label = "\"По трем точкам\" - построение по трем точкам съёмки";}
:text {label = "которые были выбраны первыми им множества отснятых точек сваи";}
:text {label = "построение не всегда корректно";}
spacer_1;
:text {label = "\"По лучшему радиусу\" - построение по лучшему радиусу";}
:text {label = "который определяется из множества точек съёмки одной сваи";}
:text {label = "построение более корректно, работает медленно";}
spacer_1;
:text {label = "\"Коэффициент поиска точек\" - чем больше значение";}
:text {label = "тем больше зона поиска точек съёмки для заданного диаметра";}
spacer_1;
:text {label = "Примечание: все не построенные окружности при максимальном";}
:text {label = "коэффициенте говорят о большом \"отлёте\" съемочных точек от диаметра";}
}//boxed_column
:boxed_row {
label = "Коэффициент поиска точек";
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
:text {label = "Автор Глушко Александр, 2019г.";}
:text {label = "aleksandr-glushko@bk.ru";}
}//column
:ok_button{label = "Вернутья";}
}//dialog
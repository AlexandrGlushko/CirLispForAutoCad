;===================================================================================================
;Автоматическое построение окружности по точкам съемки
;===================================================================================================

(defun c:cir()
	(setq Input 0)									;Флаг готовности к построению
	(setq Func_Draw 0)							;Флаг выбора функции для отрисовки
	(setq Set_Obj_Point nil)				;Тип объекта для поиска
	(setq Set_Layer_Find nil)				;Слой для поиска
	(setq Set_Diam 0.630)						;Диаметр для поиска соседних точек
	(setq Set_Coef_Diam 1.07)				;Коэффициент искажнеия для поиска нужного диаметра
	(setq Set_Max_Diam (* Set_Diam Set_Coef_Diam))				;Максимальный диаметр для поиска и отрисовки
	(setq Set_Min_Diam (* Set_Diam (- 2 Set_Coef_Diam)))	;Минимальный диаметр для откисовки
	(setq Set_Name_Layer "Съемка")	;Имя слоя для рисования
	(setq Set_Color_Layer 1)				;Цвет слоя
	(Dialog)												;Запуск диалогового окна
	(Clear_Memory)									;Очистка памяти
	(princ)													;Тихай выход
);End Cir

;===================================================================================================
;Функция обнуления глобальных переменных
;===================================================================================================

(defun Clear_Memory()
	(setq Set_Obj_Point nil)	;Тип объекта для поиска
	(setq Set_Layer_Find nil)	;Слой для поиска
	(setq Input 0)						;Флаг готовности к построению
	(setq Func_Draw 0)				;Флаг выбора функции для отрисовки
	(setq list_point nil)			;Список найденных точек функцией Find_Point
	(setq gruop_list nil)			;Список групп точек составленной функцией List_For_Draw 
)

;===================================================================================================
;Функция активации расширеных функций ActiveX для обработки точек COGO Civli3D
;===================================================================================================

(defun Load_ActiveX()
  (vl-load-com)
  (setq Acad_Application (vlax-get-acad-object))
  (setq Active_Document (vla-get-ActiveDocument Acad_Application))
  (setq Model_Space (vla-get-ModelSpace Active_Document))
  (setq Paper_Space (vla-get-PaperSpace Active_Document))
);End Load_ActiveX

;===================================================================================================
;Функция ввода и проверки начальных значений
;===================================================================================================

(defun Initialization(/ q dx dy )
	(if (null Set_Obj_Point) (setq Input -2) (setq Input 1))		;Выбраны или нет точки съемки
 	(List_layer)					      																;Создание списка слоев
  (start_list "layer_take")								
 	(mapcar 'add_list list_of_layer)														;Загрузка списка в диалог
  (end_list)
	(set_tile "diam_take" (rtos (* Set_Diam 1000)))							;Диаметр, мм
  (set_tile "layer_name" Set_Name_Layer)											;Имя слоя
	;Установка имени слоя в списке и вкл/отк поля ввода
	(if (/= Set_Name_Layer "Съемка")
		(progn
			(setq pos_lis_lay (vl-position Set_Name_Layer list_of_layer))
			(if (= pos_lis_lay nil)
				(setq list_of_layer (append list_of_layer (list Set_Name_Layer)))
				(progn
					(set_tile "layer_take" (itoa pos_lis_lay))
					(if (> pos_lis_lay 0) (mode_tile "layer_name" 1)(mode_tile "layer_name" 0))
					(setq Set_Name_Layer (nth pos_lis_lay list_of_layer))
				);End progn
			);End if
		);End progn
	);End if
	;Выбор цвета слоя и заливка кнопки выбора
  (setq dx (dimx_tile "colortake") dy (dimy_tile "colortake"))
  (start_image "colortake")
  (fill_image 0 0 dx dy Set_Color_Layer)											;Цвет слоя
  (end_image)
);End Initialization

;===================================================================================================
;Функция запуска построения окуржностей
;	Draw_Circle   - построение окружности по первым трем точкам в группе
;	Draw_Circle_2 - построение окружности по лучшему радиусу из множества точек группы
;===================================================================================================

(defun Start_Build(Input /)
(Initialization)																								;Контрольная проверка данных
(if (= Input 1)																									;При нормальных вводных данных
	(progn
		(Find_Point)																								;Поиск точек на черетже
		(List_For_Draw)																							;Составление групп из точек
		(if (= Func_Draw 0) (Draw_Circle) (Draw_Circle_2)) 					;Построение в дной из функций
	);progn
	(progn
		(cond
			((= Input -1) (alert "Введите ДИАМЕТР сваи, мм"))					;Выдача сообщений о не верно
			((= Input -2) (alert "Выберите ТОЧКУ(И) СЪЕМКИ"))					;введенных или не введенных
			((= Input -3) (alert "Введите ИМЯ СЛОЯ для Построения"))	;начальных значениях
		);cond
	);progn
);if  
);End Start_Dtaw

;===================================================================================================
;Функция проверки ввода Диаметра
;===================================================================================================

(defun Input_Diam(Diam / dm)
	(setq dm (atoi Diam))
	(if (or (null dm) (minusp dm) (zerop dm))
  (progn
		(setq Input -1)		;Флаг запрета
  );progn
  (progn
		(setq Set_Diam (/ (float dm) 1000))									;Присвоить диаметр
		(setq Set_Max_Diam (* Set_Diam Set_Coef_Diam))			;Максимальный диаметр для поиска и отрисовки
		(setq Set_Min_Diam (* Set_Diam (- 2 Set_Coef_Diam)));Минимальный диаметр для откисовки
		(setq Input 1) 		;Флаг разрешения
  );prong
 );if	  
);End Input_Diam

;===================================================================================================
;Функция проверки ввод Имени слоя
;===================================================================================================

(defun Input_Layer_Name(L_Name)
	(if (or (= L_Name "") (null L_Name))
	  (progn
	  	(setq Input -3)								;Флаг запрета 
	  );progn
	  (progn
		(setq Set_Name_Layer L_Name)		;Присвоить имя слоя
		(setq Input 1)									;Флаг разрешения
	  );progn
	);if
);End Input_Diam

;===================================================================================================
;Функция проверки Выбора слоя из списка
;===================================================================================================

(defun Input_Layer(Layer / i)
	(setq i (atoi Layer))
	(if (> i 0) (mode_tile "layer_name" 1)(mode_tile "layer_name" 0))
	(setq Set_Name_Layer (nth i list_of_layer))
);End Input_Diam

;===================================================================================================
; Функция составление списка слоев текущего чертежа
; list_of_layer - список слоев формата string
;===================================================================================================

(defun List_layer(/ temp lay_list lay1 lay2 tmp_elem i)
  (setq temp T)
  (setq lay_list '())
  (setq lay1 (tblnext "LAYER" T))
  (setq lay_list (append lay_list (list lay1)))
  (while (/= temp nil)
		(setq lay2 '())
		(setq lay2 (tblnext "LAYER"))
		(setq temp lay2)
		(setq lay_list (append lay_list (list temp)))
  )
  (setq i 0)
  (setq list_of_layer '())
  (repeat (length lay_list)
		(setq tmp_elem (cdr (assoc 2 (nth i lay_list))))
		(if (/= tmp_elem nil )(setq list_of_layer (append list_of_layer (list tmp_elem))))
		(setq i (1+ i))
  );End repeat
  (setq list_of_layer (cons "Создать" list_of_layer))
);End List_layer

;===================================================================================================
;Функция выбора элемента съмки по элементам модели
;При выборе объекта присваивает параметры:
;	Ent_point - тип объекта для поиска
;	Ent_layer - слой на котором расположены объекты для поиска
;===================================================================================================

 (defun Enter_Data_Take(/ Ent_layer Ent_point Ent_data First_Elem)
   	(setq Ent_layer "")
   	(setq Ent_point "")
	(setq Ent_data (ssget))					;Выбор элемента пользователем
   	(if (null Ent_data)
	  (progn
	  	(print "Ничего не выбранно")
	  )
	  (progn
   		(setq First_Elem (entget (ssname Ent_data 0)))
   		(setq Ent_point (cdr (assoc 0 First_Elem)))
    	(setq Ent_layer (cdr (assoc 8 First_Elem)))
   		(princ "Выбранный слой: ") (princ Ent_layer) (print)
   		(princ "Выбранный тип объекта: ") (princ Ent_point) (print)
		(setq Set_Obj_Point Ent_point)
   	(setq Set_Layer_Find Ent_layer)
	  )
	);if Ent_data
 );End Enter_Data_Take

;===================================================================================================
; Функция вызова диалогового окан для присвоения цвета
; и заливки цветом кнопкпи выбора
; - Set_Color_Layer
;===================================================================================================
  
(defun Enter_Color_Take(/ dx dy tk_col)
  	(setq dx (dimx_tile "colortake") dy (dimy_tile "colortake"))
  	(setq tk_col (acad_colordlg Set_Color_Layer))
  	(if (null tk_col) (princ)
  	(setq Set_Color_Layer tk_col))
  	(start_image "colortake")
  	(fill_image 0 0 dx dy Set_Color_Layer)
  	(end_image)
);End Enter_Color_Take
 
;===================================================================================================
; Функция вызова основного диалогового окна
;===================================================================================================

(defun Dialog()
  (setq name_dcl "CIR.dcl")
	(setq dcl_id (load_dialog name_dcl))
	(if (= dcl_id -1)
	  (progn
	  (print) (princ "Файл ") (princ name_dcl) (princ " не найден") (print)
	  (exit)
	  )
	);if dcl_id
  	(setq enter 2)
  	(while (>= enter 2) ;Основной цикл окна
  	(setq new_dial (new_dialog "main_cir" dcl_id))
	  	(if (null new_dial)
			  (progn
					(print "Не смог загрузить диалоговое окно")
					(exit)
			  )
			);End if
			(Initialization) ;Проверка введенных данных
			(action_tile "diam_take" "(Input_Diam (get_tile \"diam_take\"))")
			(action_tile "layer_take" "(Input_Layer (get_tile \"layer_take\"))")
			(action_tile "layer_name" "(Input_Layer_Name (get_tile \"layer_name\"))")
			(action_tile "colortake" "(Enter_Color_Take)")
			(action_tile "cir1" "(setq Func_Draw 0)")
			(action_tile "cir2" "(setq Func_Draw 1)") 
			(action_tile "accept" "(done_dialog 1)")
			(action_tile "cancel" "(done_dialog)")
			(action_tile "help" "(Help_Dialog dcl_id)")
			
			(setq enter (start_dialog))
			  (cond
				  ((= enter 10) (Enter_Data_Take))	;Выбор точек съемки
				  ((= enter 9) (Start_Build Input))	;Построение с возвратом из диалога
				  ((= enter 1) (Start_Build Input))	;Построение с выходом из диалога
			  );cond
		);Конец основного цикла окна
	(unload_dialog dcl_id)
	(princ)
); End Dialog

;===================================================================================================
; Функция вызова окна справки
;===================================================================================================

(defun Help_Dialog(id)
	(new_dialog "help_cir" id)
	(set_tile "Show_slide_val" (rtos Set_Coef_Diam)) ;Присвоить значение коэффициента
	(action_tile "slid_val" "(Slider_Val $value)")
	(start_dialog)
);End Help_Dialog

;===================================================================================================
; Функция управления полосой прокрутки для фоэффициента поиска точек
;===================================================================================================

(defun Slider_Val(val)
	(setq Set_Coef_Diam (/(float(atoi val))100))
	(set_tile "Show_slide_val" (rtos Set_Coef_Diam))
);End Slider_Val

;===================================================================================================
; Функция поиска точек по типу объекта и на слое указанном в функции Enter_Data_Take
; list_point - список всех найденных точек в чертеже
;===================================================================================================

(defun Find_Point(/ i point_list xyz_list)
(setq list_point '())
(setq nab_point (ssget "_X" (list (cons 8 Set_Layer_Find) (cons 0 Set_Obj_Point))))
(if (null nab_point)
	(progn
	(print "Нет точек на данном слое")
	(exit)
)
(progn
	(princ "Количество точек для построения: ") (prin1 (sslength nab_point)) 
)
);if nab_point
	(if (= Set_Obj_Point "AECC_COGO_POINT")
		(progn
			(Load_ActiveX)
			(setq nab_lenght (sslength nab_point))
			(setq i -1)
				(repeat nab_lenght
					(setq i (1+ i))
					(setq vlx_point (vlax-ename->vla-object (ssname nab_point i)))
					(setq xyz_list (list  (vlax-get-property vlx_point 'Easting)
					(vlax-get-property vlx_point 'Northing)
					(vlax-get-property vlx_point 'Elevation)))
					(setq list_point (append list_point (list xyz_list)))
				);repeat nab_lenght 
		);End progn true
		(progn
			(setq nab_lenght (sslength nab_point))
			(setq i -1)
			(repeat nab_lenght
				(setq i (1+ i))
				(setq point_list (entget (ssname nab_point i)))
				(setq xyz_list (cdr (assoc 10 point_list)))
				(setq list_point (append list_point (list xyz_list)))
			);repeat nab_lenght
		); End progn false
	);End if
);End Find_Point

;===================================================================================================
;Функция поиска и формирования групп точек для рисования
;Измеряеться расстояния между всеми точками по очереди
;На основании наименьшей длины согласно ВВЕДЕННОГО диаметра
;Точки собираются в группы, затем все группы добавляються в общий список для печати
;Повторения исключены на этапе добавлении группы в список групп
; gruop_list - список групп точек
;===================================================================================================

(defun List_For_Draw(/ temp_gruop p1 p2 j i have_data temp_elem gruop_elem)
  	(setq gruop_list '())			;Список групп точек
  	(setq temp_gruop '())			;Группа кандидат на добавление в список
  	(setq i 0)								;Внешний перебор
  	(setq j 0)								;Внутренний перебор
  	(repeat nab_lenght				;Перебор всех точек чертежа и создание групп точек
			(setq p1 (nth i list_point)) 					;Внешний перебор
	  	(setq temp_gruop (append temp_gruop (list p1)))	;Первая точка в группе
		 		(repeat nab_lenght
				(setq p2 (nth j list_point)) 				;Внутренний перебор
				(if (/= p1 p2) (setq dist (distance p1 p2)))
					;Если точки не совпадают и расстояние между точками <= Максимального диаметра
					; и между точками боьше 2 см
			  	(if (and (/= p1 p2) (<= dist Set_Max_Diam) (>= dist 0.02))
				  (setq temp_gruop (append temp_gruop (list p2)))) 
			  (setq j (1+ j)) ;Итерация внутренний перебор	
				);repeat
			
;Перед добавлением кандидата (temp_gruop)проверяеться последний добавленный элемент в (gruop_list)
;если совпаденией нет то кандидат добавляеться если есть то пропускаеться
			
;В пустой список (gruop_list) добавляеться первый кандидат		  
	  (progn
	  	(setq have_data (length gruop_list))				
	    	(if (= have_data 0)
		  	;Певый кандидат в пустом списке
				(setq gruop_list (append gruop_list (list temp_gruop)))		
		  	(progn
			    	;Последний добавленный кандидат
			    (setq gruop_elem (nth (- (length gruop_list) 1) gruop_list))
			  		;Первый элемент кандидата на добавление	
			    (setq temp_elem (nth 0 temp_gruop))
			  		;Проверка на принадлежность элемента к последнему списку
			    (setq have_elem (member temp_elem gruop_elem))		
			    (if (null have_elem )
			      	;Если нет такого элемента в списке то добавляем новый список
			      (setq gruop_list (append gruop_list (list temp_gruop)))
			    );if
			);progn		  
		);if
	  );progn
	  (setq temp_gruop '()) ;Обнуление группы кандидата  
	  (setq j 0)			;и счетчика внутреннего перебора
	  (setq i (1+ i))		;Итерация Внешнего перебора
	);End repeat	
);End List_For_Draw

;===================================================================================================
;Функция рисования окружностей по первым трем точкам в группе
;===================================================================================================

(defun Draw_Circle( / )
  	(setvar "CMDECHO" 0)
		(setvar "OSMODE" 0)
  	(command-s "._-LAYER" "_M" Set_Name_Layer "_C" Set_Color_Layer "" "")
  	(setq counter 0)				;Счетчик отрисованных кругов
		(setq no_counter 0)			;Счетчик групп с количеством точек для построения < 3
  	(setq i 0)							;Индекс для перебора групп точек
  	(setq print_list '())				;Список точек для печати
  	(repeat (length gruop_list)			;Перебор списка групп точек
	  	(setq print_list (nth i gruop_list))	;Список точек <- [Индекс] списка группы точек 
	  	(setq pr_length (length print_list))	;Количество точе в списке для рисования
	  	(if (>= pr_length 3)			;Если точек 3 и более то рисуем
		  (progn
		    (command-s "_.CIRCLE" "_3P" (nth 0 print_list) (nth 1 print_list) (nth 2 print_list))
			(setq last_obj (entlast))
			(setq tmp_cir (entget last_obj))
			(entdel last_obj)
			(setq new_cir_pos (cdr (assoc 10 tmp_cir)))
			(setq new_cir_rad (cdr (assoc 40 tmp_cir)))
			(if (and (<= new_cir_rad (/ Set_Max_Diam 2)) (>= new_cir_rad (/ Set_Min_Diam 2)))
			  (progn			  
				(command-s "_.CIRCLE" new_cir_pos new_cir_rad)
				(setq counter (1+ counter))	;Итерация счетчика отрисованных кругов
			  );progn
			 );if
		  )
		 (progn (setq no_counter (1+ no_counter))) ;Мало точек для построения
		);End if
	 (setq print_list '())					;Очистка списка печати	
	 (setq i (1+ i))					;Итерация индекса списка из групп точек
	);End repeat
		(setvar "OSMODE" 1)
  	(setvar "CMDECHO" 1)
		(print) (princ "Групп с количеством точек меньше трех: ") (prin1 no_counter)
  	(print) (princ "Количество построенных окружностей: ") (prin1 counter)
);End Draw_Cirle

;===================================================================================================
;Функция рисования окружностей по лучшему радиасу при 4 и более точках в группе
;===================================================================================================

(defun Draw_Circle_2( / )
(setvar "CMDECHO" 0)
(setvar "OSMODE" 0)
(command-s "._-LAYER" "_M" Set_Name_Layer "_C" Set_Color_Layer "" "")
(setq counter 0)
(setq no_counter 0)
(setq i 0)												
(setq print_list '())				
(repeat (length gruop_list)				
(setq print_list (nth i gruop_list))
(setq pr_length (length print_list))
(if (>= pr_length 3)				
	(progn
	(setq radius_list '())
	(setq p1 0)
	(setq p2 1)
	(setq p3 2)
	(repeat pr_length ;p1
		(repeat pr_length ;p2
			(repeat pr_length ;p3
				(if (and (/= p1 p2) (/= p1 p3) (/= p2 p3))
					(progn
					(command-s "_.CIRCLE" "_3P" (nth p1 print_list) (nth p2 print_list) (nth p3 print_list))
					(setq last_obj (entlast))
					(setq tmp_cir (entget last_obj))
					(entdel last_obj)
					(setq tmp_cand (list (cons (cdr (assoc 40 tmp_cir)) (cdr(assoc 10 tmp_cir)))))
					(if (/= (car (car tmp_cand)) nil)
						(if (null (member tmp_cand radius_list)) (setq radius_list (append radius_list tmp_cand)))
					)
					(setq tmp_cand '())
					);progn
				);End if
			(setq p3 (1+ p3))
			(if (= p3 pr_length) (setq p3 (- p3 1)))
			);repeat p3
			(setq p3 2)
			(setq p2 (1+ p2))
			(if (= p2 pr_length) (setq p2 (- p2 1)))
			);repeat p2
		(setq p2 1)
		(setq p1 (1+ p1))
		(if (= p1 pr_length) (setq p1 (- p1 1)))
	);repeat p1
	(setq difer_list (mapcar '(lambda (elem) (abs (- (/ Set_Diam 2) (car elem))))radius_list))
	(setq some_min (car (vl-sort difer_list '<)))
	(setq pos_rad (vl-position some_min difer_list))
	(setq new_cir_pos (cdr (nth pos_rad radius_list)))
	(setq new_cir_rad (car (nth pos_rad radius_list)))
		(if (and (<= new_cir_rad (/ Set_Max_Diam 2)) (>= new_cir_rad (/ Set_Min_Diam 2)))
			(progn			  
			(command-s "_.CIRCLE" new_cir_pos new_cir_rad)
			(setq counter (1+ counter)) ;Итерация счетчика отрисованных кругов
			);progn
		);if
	);progn
		(setq no_counter (1+ no_counter)) ;Мало точек для построения
	);End if
(setq radius_list '())
(setq print_list '())	
(setq i (1+ i))		
);End repeat
(setvar "OSMODE" 1)
(setvar "CMDECHO" 1)
(print) (princ "Групп с количеством точек меньше трех: ") (prin1 no_counter)
(print) (princ "Количество построенных окружностей: ") (prin1 counter)
);End Draw_Cirle

;===================================================================================================

(defun TestGit)
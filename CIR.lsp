;===================================================================================================
;�������������� ���������� ���������� �� ������ ������
;===================================================================================================

(defun c:cir()
	(setq Input 0)									;���� ���������� � ����������
	(setq Func_Draw 0)							;���� ������ ������� ��� ���������
	(setq Set_Obj_Point nil)				;��� ������� ��� ������
	(setq Set_Layer_Find nil)				;���� ��� ������
	(setq Set_Diam 0.630)						;������� ��� ������ �������� �����
	(setq Set_Coef_Diam 1.07)				;����������� ��������� ��� ������ ������� ��������
	(setq Set_Max_Diam (* Set_Diam Set_Coef_Diam))				;������������ ������� ��� ������ � ���������
	(setq Set_Min_Diam (* Set_Diam (- 2 Set_Coef_Diam)))	;����������� ������� ��� ���������
	(setq Set_Name_Layer "������")	;��� ���� ��� ���������
	(setq Set_Color_Layer 1)				;���� ����
	(Dialog)												;������ ����������� ����
	(Clear_Memory)									;������� ������
	(princ)													;����� �����
);End Cir

;===================================================================================================
;������� ��������� ���������� ����������
;===================================================================================================

(defun Clear_Memory()
	(setq Set_Obj_Point nil)	;��� ������� ��� ������
	(setq Set_Layer_Find nil)	;���� ��� ������
	(setq Input 0)						;���� ���������� � ����������
	(setq Func_Draw 0)				;���� ������ ������� ��� ���������
	(setq list_point nil)			;������ ��������� ����� �������� Find_Point
	(setq gruop_list nil)			;������ ����� ����� ������������ �������� List_For_Draw 
)

;===================================================================================================
;������� ��������� ���������� ������� ActiveX ��� ��������� ����� COGO Civli3D
;===================================================================================================

(defun Load_ActiveX()
  (vl-load-com)
  (setq Acad_Application (vlax-get-acad-object))
  (setq Active_Document (vla-get-ActiveDocument Acad_Application))
  (setq Model_Space (vla-get-ModelSpace Active_Document))
  (setq Paper_Space (vla-get-PaperSpace Active_Document))
);End Load_ActiveX

;===================================================================================================
;������� ����� � �������� ��������� ��������
;===================================================================================================

(defun Initialization(/ q dx dy )
	(if (null Set_Obj_Point) (setq Input -2) (setq Input 1))		;������� ��� ��� ����� ������
 	(List_layer)					      																;�������� ������ �����
  (start_list "layer_take")								
 	(mapcar 'add_list list_of_layer)														;�������� ������ � ������
  (end_list)
	(set_tile "diam_take" (rtos (* Set_Diam 1000)))							;�������, ��
  (set_tile "layer_name" Set_Name_Layer)											;��� ����
	;��������� ����� ���� � ������ � ���/��� ���� �����
	(if (/= Set_Name_Layer "������")
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
	;����� ����� ���� � ������� ������ ������
  (setq dx (dimx_tile "colortake") dy (dimy_tile "colortake"))
  (start_image "colortake")
  (fill_image 0 0 dx dy Set_Color_Layer)											;���� ����
  (end_image)
);End Initialization

;===================================================================================================
;������� ������� ���������� �����������
;	Draw_Circle   - ���������� ���������� �� ������ ���� ������ � ������
;	Draw_Circle_2 - ���������� ���������� �� ������� ������� �� ��������� ����� ������
;===================================================================================================

(defun Start_Build(Input /)
(Initialization)																								;����������� �������� ������
(if (= Input 1)																									;��� ���������� ������� ������
	(progn
		(Find_Point)																								;����� ����� �� �������
		(List_For_Draw)																							;����������� ����� �� �����
		(if (= Func_Draw 0) (Draw_Circle) (Draw_Circle_2)) 					;���������� � ���� �� �������
	);progn
	(progn
		(cond
			((= Input -1) (alert "������� ������� ����, ��"))					;������ ��������� � �� �����
			((= Input -2) (alert "�������� �����(�) ������"))					;��������� ��� �� ���������
			((= Input -3) (alert "������� ��� ���� ��� ����������"))	;��������� ���������
		);cond
	);progn
);if  
);End Start_Dtaw

;===================================================================================================
;������� �������� ����� ��������
;===================================================================================================

(defun Input_Diam(Diam / dm)
	(setq dm (atoi Diam))
	(if (or (null dm) (minusp dm) (zerop dm))
  (progn
		(setq Input -1)		;���� �������
  );progn
  (progn
		(setq Set_Diam (/ (float dm) 1000))									;��������� �������
		(setq Set_Max_Diam (* Set_Diam Set_Coef_Diam))			;������������ ������� ��� ������ � ���������
		(setq Set_Min_Diam (* Set_Diam (- 2 Set_Coef_Diam)));����������� ������� ��� ���������
		(setq Input 1) 		;���� ����������
  );prong
 );if	  
);End Input_Diam

;===================================================================================================
;������� �������� ���� ����� ����
;===================================================================================================

(defun Input_Layer_Name(L_Name)
	(if (or (= L_Name "") (null L_Name))
	  (progn
	  	(setq Input -3)								;���� ������� 
	  );progn
	  (progn
		(setq Set_Name_Layer L_Name)		;��������� ��� ����
		(setq Input 1)									;���� ����������
	  );progn
	);if
);End Input_Diam

;===================================================================================================
;������� �������� ������ ���� �� ������
;===================================================================================================

(defun Input_Layer(Layer / i)
	(setq i (atoi Layer))
	(if (> i 0) (mode_tile "layer_name" 1)(mode_tile "layer_name" 0))
	(setq Set_Name_Layer (nth i list_of_layer))
);End Input_Diam

;===================================================================================================
; ������� ����������� ������ ����� �������� �������
; list_of_layer - ������ ����� ������� string
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
  (setq list_of_layer (cons "�������" list_of_layer))
);End List_layer

;===================================================================================================
;������� ������ �������� ����� �� ��������� ������
;��� ������ ������� ����������� ���������:
;	Ent_point - ��� ������� ��� ������
;	Ent_layer - ���� �� ������� ����������� ������� ��� ������
;===================================================================================================

 (defun Enter_Data_Take(/ Ent_layer Ent_point Ent_data First_Elem)
   	(setq Ent_layer "")
   	(setq Ent_point "")
	(setq Ent_data (ssget))					;����� �������� �������������
   	(if (null Ent_data)
	  (progn
	  	(print "������ �� ��������")
	  )
	  (progn
   		(setq First_Elem (entget (ssname Ent_data 0)))
   		(setq Ent_point (cdr (assoc 0 First_Elem)))
    	(setq Ent_layer (cdr (assoc 8 First_Elem)))
   		(princ "��������� ����: ") (princ Ent_layer) (print)
   		(princ "��������� ��� �������: ") (princ Ent_point) (print)
		(setq Set_Obj_Point Ent_point)
   	(setq Set_Layer_Find Ent_layer)
	  )
	);if Ent_data
 );End Enter_Data_Take

;===================================================================================================
; ������� ������ ����������� ���� ��� ���������� �����
; � ������� ������ ������� ������
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
; ������� ������ ��������� ����������� ����
;===================================================================================================

(defun Dialog()
  (setq name_dcl "CIR.dcl")
	(setq dcl_id (load_dialog name_dcl))
	(if (= dcl_id -1)
	  (progn
	  (print) (princ "���� ") (princ name_dcl) (princ " �� ������") (print)
	  (exit)
	  )
	);if dcl_id
  	(setq enter 2)
  	(while (>= enter 2) ;�������� ���� ����
  	(setq new_dial (new_dialog "main_cir" dcl_id))
	  	(if (null new_dial)
			  (progn
					(print "�� ���� ��������� ���������� ����")
					(exit)
			  )
			);End if
			(Initialization) ;�������� ��������� ������
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
				  ((= enter 10) (Enter_Data_Take))	;����� ����� ������
				  ((= enter 9) (Start_Build Input))	;���������� � ��������� �� �������
				  ((= enter 1) (Start_Build Input))	;���������� � ������� �� �������
			  );cond
		);����� ��������� ����� ����
	(unload_dialog dcl_id)
	(princ)
); End Dialog

;===================================================================================================
; ������� ������ ���� �������
;===================================================================================================

(defun Help_Dialog(id)
	(new_dialog "help_cir" id)
	(set_tile "Show_slide_val" (rtos Set_Coef_Diam)) ;��������� �������� ������������
	(action_tile "slid_val" "(Slider_Val $value)")
	(start_dialog)
);End Help_Dialog

;===================================================================================================
; ������� ���������� ������� ��������� ��� ������������ ������ �����
;===================================================================================================

(defun Slider_Val(val)
	(setq Set_Coef_Diam (/(float(atoi val))100))
	(set_tile "Show_slide_val" (rtos Set_Coef_Diam))
);End Slider_Val

;===================================================================================================
; ������� ������ ����� �� ���� ������� � �� ���� ��������� � ������� Enter_Data_Take
; list_point - ������ ���� ��������� ����� � �������
;===================================================================================================

(defun Find_Point(/ i point_list xyz_list)
(setq list_point '())
(setq nab_point (ssget "_X" (list (cons 8 Set_Layer_Find) (cons 0 Set_Obj_Point))))
(if (null nab_point)
	(progn
	(print "��� ����� �� ������ ����")
	(exit)
)
(progn
	(princ "���������� ����� ��� ����������: ") (prin1 (sslength nab_point)) 
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
;������� ������ � ������������ ����� ����� ��� ���������
;����������� ���������� ����� ����� ������� �� �������
;�� ��������� ���������� ����� �������� ���������� ��������
;����� ���������� � ������, ����� ��� ������ ������������ � ����� ������ ��� ������
;���������� ��������� �� ����� ���������� ������ � ������ �����
; gruop_list - ������ ����� �����
;===================================================================================================

(defun List_For_Draw(/ temp_gruop p1 p2 j i have_data temp_elem gruop_elem)
  	(setq gruop_list '())			;������ ����� �����
  	(setq temp_gruop '())			;������ �������� �� ���������� � ������
  	(setq i 0)								;������� �������
  	(setq j 0)								;���������� �������
  	(repeat nab_lenght				;������� ���� ����� ������� � �������� ����� �����
			(setq p1 (nth i list_point)) 					;������� �������
	  	(setq temp_gruop (append temp_gruop (list p1)))	;������ ����� � ������
		 		(repeat nab_lenght
				(setq p2 (nth j list_point)) 				;���������� �������
				(if (/= p1 p2) (setq dist (distance p1 p2)))
					;���� ����� �� ��������� � ���������� ����� ������� <= ������������� ��������
					; � ����� ������� ����� 2 ��
			  	(if (and (/= p1 p2) (<= dist Set_Max_Diam) (>= dist 0.02))
				  (setq temp_gruop (append temp_gruop (list p2)))) 
			  (setq j (1+ j)) ;�������� ���������� �������	
				);repeat
			
;����� ����������� ��������� (temp_gruop)������������ ��������� ����������� ������� � (gruop_list)
;���� ����������� ��� �� �������� ������������ ���� ���� �� �������������
			
;� ������ ������ (gruop_list) ������������ ������ ��������		  
	  (progn
	  	(setq have_data (length gruop_list))				
	    	(if (= have_data 0)
		  	;����� �������� � ������ ������
				(setq gruop_list (append gruop_list (list temp_gruop)))		
		  	(progn
			    	;��������� ����������� ��������
			    (setq gruop_elem (nth (- (length gruop_list) 1) gruop_list))
			  		;������ ������� ��������� �� ����������	
			    (setq temp_elem (nth 0 temp_gruop))
			  		;�������� �� �������������� �������� � ���������� ������
			    (setq have_elem (member temp_elem gruop_elem))		
			    (if (null have_elem )
			      	;���� ��� ������ �������� � ������ �� ��������� ����� ������
			      (setq gruop_list (append gruop_list (list temp_gruop)))
			    );if
			);progn		  
		);if
	  );progn
	  (setq temp_gruop '()) ;��������� ������ ���������  
	  (setq j 0)			;� �������� ����������� ��������
	  (setq i (1+ i))		;�������� �������� ��������
	);End repeat	
);End List_For_Draw

;===================================================================================================
;������� ��������� ����������� �� ������ ���� ������ � ������
;===================================================================================================

(defun Draw_Circle( / )
  	(setvar "CMDECHO" 0)
		(setvar "OSMODE" 0)
  	(command-s "._-LAYER" "_M" Set_Name_Layer "_C" Set_Color_Layer "" "")
  	(setq counter 0)				;������� ������������ ������
		(setq no_counter 0)			;������� ����� � ����������� ����� ��� ���������� < 3
  	(setq i 0)							;������ ��� �������� ����� �����
  	(setq print_list '())				;������ ����� ��� ������
  	(repeat (length gruop_list)			;������� ������ ����� �����
	  	(setq print_list (nth i gruop_list))	;������ ����� <- [������] ������ ������ ����� 
	  	(setq pr_length (length print_list))	;���������� ���� � ������ ��� ���������
	  	(if (>= pr_length 3)			;���� ����� 3 � ����� �� ������
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
				(setq counter (1+ counter))	;�������� �������� ������������ ������
			  );progn
			 );if
		  )
		 (progn (setq no_counter (1+ no_counter))) ;���� ����� ��� ����������
		);End if
	 (setq print_list '())					;������� ������ ������	
	 (setq i (1+ i))					;�������� ������� ������ �� ����� �����
	);End repeat
		(setvar "OSMODE" 1)
  	(setvar "CMDECHO" 1)
		(print) (princ "����� � ����������� ����� ������ ����: ") (prin1 no_counter)
  	(print) (princ "���������� ����������� �����������: ") (prin1 counter)
);End Draw_Cirle

;===================================================================================================
;������� ��������� ����������� �� ������� ������� ��� 4 � ����� ������ � ������
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
			(setq counter (1+ counter)) ;�������� �������� ������������ ������
			);progn
		);if
	);progn
		(setq no_counter (1+ no_counter)) ;���� ����� ��� ����������
	);End if
(setq radius_list '())
(setq print_list '())	
(setq i (1+ i))		
);End repeat
(setvar "OSMODE" 1)
(setvar "CMDECHO" 1)
(print) (princ "����� � ����������� ����� ������ ����: ") (prin1 no_counter)
(print) (princ "���������� ����������� �����������: ") (prin1 counter)
);End Draw_Cirle

;===================================================================================================

(defun TestGit)
; Simulation for a coplannar strip waveguide on a
; dielectric substrate
;
; By: Levi Smith
; Date: May 25, 2015
;
; Language: Scheme
;
; File type: *.ctl used as an input file for the
;            MEEP FDTD field solver
;
;
; Comments: Gaussian source


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; User-defined variables ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Computational cell parameters
(define-param sx 200)
(define-param sy 1000)
(define-param sz 200)
(define-param dpml 30)
(define-param cell_resolution 1)

; CPS waveguide parameters 
(define-param S_cps 5)
(define-param W_cps 5)
(define-param T_cps 2)

; CPS metallization x-offset
(define-param x_cps_offset (* 0.5 (+ S_cps W_cps)))

; Substate parameters
(define-param eps 12.9)
(define-param T_sub (* 0.5 sz))

; Set source parameters
(define-param fcen (/ 1 300))
(define-param df (/ 1 600))

; Set the source position
(define-param y_pml_space 5)
(define-param y_source (+ y_pml_space (+ dpml (* -0.5 sy))))
(define-param z_source (* T_cps 0.5))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; Setup the simulation ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Setup the computational cell
(set! geometry-lattice (make lattice (size sx sy sz)))

; Setup cps geometry
(set! geometry (list
	(make block (center x_cps_offset 0 0)(size W_cps infinity T_cps)
		(material perfect-electric-conductor))
	(make block (center (* -1 x_cps_offset) 0 0)(size W_cps infinity T_cps)
		(material perfect-electric-conductor))
	(make block (center 0 0 (* -0.5 T_sub))(size infinity infinity T_sub)
		(material (make dielectric (epsilon eps))))))

; Setup PML layers
(set! pml-layers (list (make pml (thickness dpml))))

; Setup the cell resolution
(set! resolution cell_resolution) 

; Setup the source
(set! sources (list 
	(make source
		(src (make gaussian-src
			(frequency fcen)(fwidth df)))
		(component Ex)
		(center 0 y_source z_source)
		(size S_cps 0 0))))

; Run the simulation 
(run-until 6000 
	(at-beginning output-epsilon)
	(to-appended "ex_xy"
		(at-every 40 
			(in-volume (volume (center 0 0 0)(size sx sy 0))
				output-efield-x)))
	(to-appended "ex_yz"
		(at-every 40 
			(in-volume (volume (center 0 0 0)(size 0 sy sz))
				output-efield-x))))

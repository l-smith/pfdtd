; Simulation for a coplannar strip waveguide on a
; dielectric substrate
;
; By: Levi Smith
; Date: May 22, 2015
;
; Language: Scheme
;
; File type: *.ctl used as an input file for the
;            MEEP FDTD field solver
;
;
; Comments: 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; Setup variables ;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Computational cell dimensions
(define-param sx 100)
(define-param sy 1000)
(define-param sz 200)
(define-param dpml 30)
(define-param cell_resolution 1)

; CPS waveguide parameters 
(define-param S_cps 5)
(define-param W_cps 5)
(define-param T_cps 2)

; Substate parameters
(define-param eps 12.9)
(define-param T_sub (* 0.5 sz))

; Set the source position
(define-param y_pml_space 5)
(define-param y_source (- y_pml_space (- dpml (* 0.5 sy))))
(define-param z_source (* T_cps 0.5))

(define-param x_cps_offset (* 0.5 (+ S_cps W_cps)))

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
		(src (make continuous-src
			(wavelength 300)(width 300)))
		(component Ex)
		(center 0 0 z_source)
		(size S_cps 0 0))))

; Run the simulation 
(run-until 1000 
	(at-beginning output-epsilon)
	(to-appended "ex_xy"
		(at-every 10 
			(in-volume (volume (center 0 0 0)(size sx sy no-size))
				output-efield-x)))
	(to-appended "ex_yz"
		(at-every 10 
			(in-volume (volume (center 0 0 0)(size no-size sy sz))
				output-efield-x))))

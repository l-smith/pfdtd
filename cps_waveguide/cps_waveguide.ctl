; Simulations for a coplannar strip waveguide on a
; dielectric substrate
;
;
;
; File type: *.ctl used as an input file for the
;            MEEP FDTD field solver

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; Setup variables ;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Computational cell dimensions
(define-param sx 70)
(define-param sy 150)
(define-param sz 60)
(define-param dpml 10)
(define-param cell_resolution 2)

; CPS waveguide parameters 
(define-param S_cps 5)
(define-param W_cps 5)
(define-param T_cps 0.5)

; Substate parameters
(define-param eps 12.9)
(define-param T_sub (* 0.5 sz))

; Set the source position
(define-param y_pml_space 5)
(define-param y_source (- y_pml_space (- dpml (* 0.5 sy))))

(define-param x_cps_offset (* 0.5 (+ S_cps W_cps)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; Setup the simulation ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(set! geometry-lattice (make lattice (size sx sy sz)))

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
			(wavelength 100)))
		(component Ex)
		(center 0 0 0)
		(size S_cps 0 0))))

(run-until 200 
	(at-beginning output-epsilon)
	(to-appended "ex"
		(at-every 1
			(in-volume (volume (center 0 0 0)(size sx sy no-size))
				output-efield-x))))

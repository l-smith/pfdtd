; Eventually a simulation for SHG in PPLN,
; currently it is nothing


; PPLN Parameters
(define-param ppln_x 20)
(define-param ppln_y 20)
(define-param ppln_z 20)
(define-param eps 4.88896)

; Computational cell parameters
(define-param sx ppln_x)
(define-param sy ppln_y)
(define-param sz (* 3 ppln_z))
(define-param dpml 3)
(define-param cell_res 4)

; Source paramters
(define-param fcen (/ 1 1.55))
(define-param df (/ fcen 10))

; Source position
(define-param z_source (+ dpml (* sz -0.5)))

; Flux parameters
(define-param nfreq 100)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; Setup the simulation ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Setup the computational cell
(set! geometry-lattice (make lattice (size sx sy sz)))

; Setup the PPLN geometry
(set! geometry
	(list
		(make block (center 0 0 0)(size ppln_x ppln_y ppln_z)
			(material (make dielectric (epsilon eps))))))

; Setup PML Layers
(set! pml-layers (list (make pml (thickness dpml))))

; Setup the cell resolution
(set! resolution cell_res)

; Setup the source
(set! sources
	(list
		(make source
			(src (make gaussian-src
				(frequency fcen)(fwidth df)))
			(component Ex)
			(center 0 0 z_source)
			(size sx sy 0))))

; Run the simulation
(run-until 300
	(at-beginning output-epsilon)
	(to-appended "ex_xy"
		(at-every 0.1
			(in-volume (volume (center 0 0 0)(size sx sy 0))
				output-efield-x)))
	(to-appended "ex_yz"
		(at-every 0.1 
			(in-volume (volume (center 0 0 0)(size 0 sy sz))
				output-efield-x))))


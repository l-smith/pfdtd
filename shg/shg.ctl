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
(define-param z_source (+ dpml (* ppln_z -0.5)))

; Flux parameters
(define-param nfreq 100)
(define-param rx_flux_z (+ dpml (* -0.49 sz)))
(define-param tx_flux_z (* -1 rx_flux_z))


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
; Setup Flux regions
(define trans
	(add-flux fcen df nfreq
		(make flux-region
			(center 0 0 tx_flux_z)(size sx sy 0)))) 
(define refl 
	(add-flux fcen df nfreq
		(make flux-region
			(center 0 0 rx_flux_z)(size sx sy 0)))) 

(run-sources+
	(stop-when-fields-decayed 50 Ex
		(vector3 0 0 tx_flux_z) 1e-3)
	(to-appended "ex_yz"
		(at-every 0.25 
			(in-volume (volume (center 0 0 0)(size sx sy 0))
				output-efield-x))))

;(save-flux "trans-flux" trans)
;(save-flux "refl-flux" refl)
;(display-fluxes refl)
(display-fluxes trans) 
(display-fluxes refl) 
; Run the simulation
;(run-until 300
	;(at-beginning output-epsilon)
	;(to-appended "ex_xy"
		;(at-every 0.1
			;(in-volume (volume (center 0 0 0)(size sx sy 0))
				;output-efield-x)))
	;(to-appended "ex_yz"
		;(at-every 0.1 
			;(in-volume (volume (center 0 0 0)(size 0 sy sz))
				;output-efield-x)))) 

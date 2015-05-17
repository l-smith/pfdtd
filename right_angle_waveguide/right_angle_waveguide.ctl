; Setup the computational cell
(set! geometry-lattice (make lattice (size 16 16 no-size)))


; Make two blocking intersecting at a right angle
(set! geometry (list
	(make block (center -2 -3.5)(size 12 1 infinity)
		(material (make dielectric (epsilon 12))))
	(make block (center 3.5 2)(size 1 12 infinity)
		(material (make dielectric (epsilon 12))))))

; Setup pml region inside the compuational cell
(set! pml-layers (list (make pml (thickness 1.0))))

; Set the resoltion
(set! resolution 10)

; Setup the source
(set! sources (list
	(make source
		(src (make continuous-src
			(wavelength (* 2 (sqrt 12)))(width 20)))
		(component Ez)
		(center -7 -3.5)(size 0 1))))

; Run the simulation for 200 time steps, save data every 0.6
(run-until 200
	(at-beginning output-epsilon)
	(to-appended "ez" (at-every 0.6 output-efield-z)))

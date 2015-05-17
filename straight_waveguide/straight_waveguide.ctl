; Example form meep tutorial
; Straight Waveguide

; Setup the computational cell
(set! geometry-lattice (make lattice (size 16 8 no-size)))

; Make the straight waveguide with a dielectric constant of 12
(set! geometry (list
	(make block (center 0 0) (size infinity 1 infinity)
		(material (make dielectric (epsilon 12))))))

; Create a current source at -7 0
(set! sources (list
	(make source
		(src (make continuous-src (frequency 0.15)))
		(component Ez)
		(center -7 0))))

; Add pml regions inside the compuational cell
(set! pml-layers (list (make pml (thickness 1.0))))

; Set the number of points per computational cell
(set! resolution 10)

; Run the simulation for 200 time steps.
; Output *.h5 file for dielectric profile at the beginning.
; Output *.h5 file for Ez at the end 
(run-until 200
	(at-beginning output-epsilon)
	(at-end output-efield-z))

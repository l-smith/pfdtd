(set! geometry-lattice (make lattice (size 5 5 5)))

(set! geometry (list
	(make source
		(src (make continuous-src frequency 0.1)))
		(component Ez)
		(center 0 0))))


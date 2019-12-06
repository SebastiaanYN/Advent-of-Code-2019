(use '[clojure.string :only (split)])

(defn count-orbits [objects known object]
  (if (contains? known object)
    [(get known object) known] ; if the count is already known return it

    (if (contains? objects object) ; check if the object orbits another object
      (let [[orbit-count new-known] (count-orbits objects known (get objects object))]

        ; store the count
        [(inc orbit-count)
         (persistent! (assoc! (transient new-known) object (inc orbit-count)))])

      [0 known]))) ; the object doesn't orbit another object

(defn find-orbit-counts [objects object]
  (second (count-orbits objects (hash-map) object)))

(defn find-minimal-transfers [objects]
  (let [you (find-orbit-counts objects "YOU")
        san (find-orbit-counts objects "SAN")
        shared-keys (filter
                     (fn [object] (contains? san object))
                     (keys you))]

    (apply min (map
                ; sum the distance from YOU to SAN through a given object
                (fn [key] (+
                           (- (get you "YOU") (get you key) 1)
                           (- (get san "SAN") (get san key) 1)))
                shared-keys))))

(def input (map
            (fn [str] (split str #"\)"))
            (split (slurp "input.txt") #"\n")))

(def objects (reduce
              (fn [map entry] (assoc map (second entry) (first entry)))
              (hash-map)
              input))

(println (find-minimal-transfers objects))

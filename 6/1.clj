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

(def input (map
            (fn [str] (split str #"\)"))
            (split (slurp "input.txt") #"\n")))

(def objects (reduce
              (fn [map entry] (assoc map (second entry) (first entry)))
              (hash-map)
              input))

(println (first (reduce
                 (fn [[sum known] object]
                   (let [[orbit-count new-known] (count-orbits objects known object)]

                     [(+ sum orbit-count) new-known]))
                 [0  (hash-map)]
                 (keys objects))))

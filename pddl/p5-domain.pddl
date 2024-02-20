(define (domain p4-domain)

(:requirements 
    :typing
    ;:numeric-fluents 
    :durative-actions
)

(:types
    valve bolt tool - content
    robot box content workstation carrier - entity
    location
)

(:constants )

(:predicates
    (at ?e - entity ?l - location)  ; entity e is at location l
    (filled ?b - box ?c - content)  ; content c is in box b
    (empty-box ?b - box)  ; box b is empty
    (content-at-workstation ?c - content ?w - workstation)  ; content c is at workstation w
    (connected ?l1 ?l2 - location)    ; location l1 is connected to location l2
    (box-at-workstation ?b - box ?w - workstation)  ; box b is at workstation w
    (on ?b - box ?c - carrier)  ; box b is on carrier c
    (use-carrier ?r - robot ?k - carrier)  ; robot r is using carrier k
    (free ?r - robot)  ; robot r is free
)


(:functions
    ;(capacity ?k - carrier)  ; total capacity of carrier k
    ;(carrier-load ?k - carrier)  ; number of boxes carrier k is holding
    ;(distance ?l1 ?l2 - location)  ; distance between location l1 and location l2
)

(:durative-action load-box-on-carrier
    :parameters (?r - robot ?b - box ?l - location ?k - carrier)
    :duration (= ?duration 2)
    :condition (and 
        (at start (and 
            (at ?b ?l)
            (free ?r)
        ))
        (over all (and 
            (at ?r ?l)
            (use-carrier ?r ?k)
            ;(< (carrier-load ?k) (capacity ?k))
        )))
    )
    :effect (and 
        (at start (and 
            (not (at ?b ?l))
            (not (free ?r))
        ))
        (at end (and
            (on ?b ?k)
            ;(increase (carrier-load ?k) 1) 
            (free ?r)
        ))
    )
)

(:durative-action fill-box
    :parameters (?r - robot ?b - box ?c - content ?l - location)
    :duration (= ?duration 2)
    :condition (and 
        (at start (and 
            (at ?c ?l) 
            (empty-box ?b)
            (free ?r)
        ))
        (over all (and 
            (at ?r ?l)
            (at ?b ?l)
        ))
    )
    :effect (and 
        (at start (and 
            (not (at ?c ?l))
            (not (free ?r))
        ))
        (at end (and
            (filled ?b ?c) 
            (free ?r)
            (not (empty-box ?b)) 
        ))
    )
)

(:durative-action empty-box-at-workstation
    :parameters (?r - robot ?b - box ?c - content ?l -location ?w - workstation)
    :duration (= ?duration 2)
    :condition (and 
        (at start (and 
            (box-at-workstation ?b ?w)
            (filled ?b ?c)
            (free ?r)
        ))
        (over all (and 
            (at ?r ?l)
            (at ?w ?l)
        ))
    )
    :effect (and 
        (at start (and 
            (not (filled ?b ?c))
            (empty-box ?b)
            (not (free ?r))
        ))
        (at end (and 
            (free ?r)
            (content-at-workstation ?c ?w)
            (not (box-at-workstation ?b ?w))
        ))
    )
)

(:durative-action move-carrier
    :parameters (?r - robot ?k - carrier ?l1 ?l2 - location)
    :duration (= ?duration (distance ?l1 ?l2))
    :condition (and 
        (at start (and 
            (at ?r ?l1)
            (at ?k ?l1) 
            (free ?r)
        ))
        (over all (and
            (connected ?l1 ?l2) 
            (use-carrier ?r ?k)
        ))
    )
    :effect (and 
        (at start (and 
            (not (at ?r ?l1)) 
            (not (at ?k ?l1))
            (not (free ?r))
        ))
        (at end (and 
            (at ?r ?l2) 
            (at ?k ?l2)
            (free ?r)
        ))
    )
)


(:durative-action deliver-box
    :parameters (?r - robot ?b - box ?l - location ?w - workstation ?c - content ?k - carrier)
    :duration (= ?duration 2)
    :condition (and 
        (at start (and 
            (on ?b ?k)
            (free ?r)   
        ))
        (over all (and 
            (at ?r ?l) 
            (use-carrier ?r ?k)
            (at ?w ?l)
            (filled ?b ?c)
        ))
    )
    :effect (and 
        (at start (and
            (not (on ?b ?k))
            (not (free ?r))
            ;(decrease (carrier-load ?k) 1) 
        ))
        (at end (and
            (box-at-workstation ?b ?w) 
            (free ?r)
        ))
    )
)

(:durative-action unload-box-from-carrier
    :parameters (?r - robot ?b - box ?k - carrier ?l - location)
    :duration (= ?duration 2)
    :condition (and 
        (at start (and 
            (on ?b ?k) 
            (free ?r)
        ))
        (over all (and 
            (at ?r ?l) 
            (use-carrier ?r ?k)
        ))
    )
    :effect (and 
        (at start (and 
            (not (on ?b ?k))
            ;(decrease (carrier-load ?k) 1) 
            (not (free ?r))
        ))
        (at end (and
            (at ?b ?l)  
            (free ?r)
        ))
    )
)


)
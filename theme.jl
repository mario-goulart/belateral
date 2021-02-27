;; belateral/theme.jl

;; Based on Michele Campeotto' <micampe@f2s.com> sawmx.
;; make-text-image function by Simon Budig <simon.budig@unix-ag.org>

(require 'x)

(let* ((font (get-font "-*-lucida-bold-r-normal-*-14-*-*-*-*-*-*"))
       (font-colors (list "olive" "black"))
       (title-width
        (lambda (w)
          (let ((w-width (car (window-dimensions w))))
            (max 0 (+ 20 (min (- w-width 55)
                              (text-width (window-name w) font)))))))
       (update-title-width
        (lambda (w)
          (if (eq (window-get w 'current-frame-style) 'belateral)
              (rebuild-frame w))))
       (make-text-image
        (lambda (string #!optional (direction 1)
                                   (color (get-color "black"))
                                   (font default-font))
          (let (drawable shapedrw gc image height width
                         (black (get-color "black"))
                         (white (get-color "white")))
            (setq width (text-width string font))
            (setq height (font-height font))

            ;; We just need to fill the main drawable with the desired color:
            ;; Text rendering is done with the Shape-Pixmap.
            (setq drawable (x-create-pixmap (cons width height)))
            (setq gc (x-create-gc drawable `((foreground . ,color))))
            (x-fill-rectangle drawable gc '(0 . 0) (cons width height))
            (x-destroy-gc gc)

            ;; Shape pixmap
            (setq shapedrw (x-create-pixmap (cons width height)))
            (setq gc (x-create-gc shapedrw `((foreground . ,black))))
            (x-fill-rectangle shapedrw gc '(0 . 0) (cons width height))
            (x-change-gc gc `((foreground . ,white)))
            ;; here are some font-properties hardcoded.
            ;; font-ascent doesnt seem to be available in gaol...
            ;; (x-draw-string shapedrw gc '(0 . (font-ascent font)) string font)
            (x-draw-string shapedrw gc '(0 . 10) string font)
            (x-destroy-gc gc)

            (setq image (x-grab-image-from-drawable drawable shapedrw))
            (x-destroy-drawable drawable)
            (x-destroy-drawable shapedrw)
            (if (or (= direction 2) (= direction 4))
                (flip-image-diagonally image))
            (if (or (= direction 2) (= direction 3))
                (flip-image-horizontally image))
            (if (or (= direction 3) (= direction 4))
                (flip-image-vertically image))
            image
            )))
       (draw-text
        (lambda (w)
          (let* ((name% (window-name w))
                 (name (if (equal name% "") "noname" name%)))
            (list
             (make-text-image name 4
                              (get-color (car font-colors)) font)
             (make-text-image name 4
                              (get-color (cadr font-colors)) font)))))

       ;; --- Images
       (border         (make-image "border.png"))
       (bottom-left    (make-image "bottom-left.png"))
       (button         (make-image "button.png"))
       (resizer        (make-image "corner.png"))
       (d-bottom-left  (make-image "d-bottom-left.png"))
       (d-left         (make-image "d-left.png"))
       (d-top-left     (make-image "d-top-left.png"))
       (d-top-right    (make-image "d-top-right.png"))
       (d-top          (make-image "d-top.png"))
       (left-light     (make-image "left-light.png"))
       (title-bottom   (make-image "title-bottom.png"))
       (title          (make-image "title.png"))
       (top-left       (make-image "top-left.png"))
       (top-light      (make-image "top-light.png"))
       (top-right      (make-image "top-right.png"))
       (corner-top-right (make-image "corner-top-right.png"))
       (corner-bottom-right (make-image "corner-bottom-right.png"))
       (corner-bottom-left (make-image "corner-bottom-left.png"))

       (frame `(
                ;; Title background
                ((background . ,title)
                 (top-edge . -4)
                 (left-edge . -23)
                 (height . ,(lambda (w) (+ (title-width w) 17)))
                 (cursor . left_ptr)
                 (class . title))

                ((background . ,draw-text)
                 (top-edge . 17)
                 (left-edge . -19)
                 (cursor . left_ptr)
                 (class . title))

                ((background . ,title-bottom)
                 (top-edge . ,(lambda (w) (+ (title-width w) 11)))
                 (left-edge . -23)
                 (cursor . left_ptr)
                 (class . title))

                ;; Top frame line
                ((background . ,top-light)
                 (left-edge . -23) ;; 3 for borderless title
                 (top-edge . -4)
                 (right-edge . 0)
                 (cursor . left_ptr)
                 (class . title))

                ;; bottom frame line
                ((background . ,top-light)
                 (left-edge . -4)
                 (bottom-edge . -4)
                 (right-edge . 0)
                 (cursor . left_ptr)
                 (class . title))

                ;; Left frame line
                ((background . ,left-light)
                 (top-edge . -1)
                 (bottom-edge . 0)
                 (left-edge . -4)
                 (cursor . left_ptr)
                 (class . title))

                ;; Right frame line
                ((background . ,left-light)
                 (top-edge . -4)
                 (bottom-edge . -4)
                 (right-edge . -4)
                 (cursor . left_ptr)
                 (class . title))

                ((background . ,bottom-left)
                 (left-edge . -4)
                 (bottom-edge . -4)
                 (cursor . left_ptr)
                 (class . title))

                ((background . ,resizer)
                 (right-edge . -1)
                 (bottom-edge . -1)
                 (cursor . sizing)
                 (class . bottom-right-corner))

                ((background . ,corner-top-right)
                 (right-edge . -4)
                 (top-edge . -4)
                 (cursor . sizing)
                 (class . top-right-corner))

                ((background . ,corner-bottom-right)
                 (right-edge . -4)
                 (bottom-edge . -4)
                 (cursor . sizing)
                 (class . bottom-right-corner))

                ((background . ,corner-bottom-left)
                 (left-edge . -4)
                 (bottom-edge . -4)
                 (cursor . sizing)
                 (class . bottom-left-corner))
                ))

       (shaped-frame `(
                       ((background . ,title)
                        (top-edge . 11)
                        (left-edge . -28)
                        (height . ,(lambda (w) (title-width w)))
                        (cursor . left_ptr)
                        (class . title))

                       ((background . ,draw-text)
                        (top-edge . 20)
                        (left-edge . -23)
                        (cursor . left_ptr)
                        (class . title))

                       ((background . ,title-bottom)
                        (top-edge . ,(lambda (w) (+ (title-width w) 11)))
                        (left-edge . -28)
                        (cursor . left_ptr)
                        (class . title))

                       ((background . ,border)
                        (top-edge . ,-9)
                        (right-edge . 8)
                        (height . 4)
                        (cursor . left_ptr)
                        (class . title))
                       ))

       (transient-frame `(((background . ,d-top-left)
                           (top-edge . -5)
                           (left-edge . -5)
                           (cursor . left_ptr)
                           (class . title))

                          ((background . ,d-top)
                           (top-edge . -5)
                           (left-edge . 0)
                           (right-edge . 4)
                           (cursor . left_ptr)
                           (class . title))

                          ((background . ,d-top-right)
                           (top-edge . -5)
                           (right-edge . -1)
                           (cursor . left_ptr)
                           (class . title))

                          ((background . ,d-left)
                           (top-edge . 0)
                           (bottom-edge . 4)
                           (left-edge . -5)
                           (cursor . left_ptr)
                           (class . title))

                          ((background . ,d-bottom-left)
                           (bottom-edge . -1)
                           (left-edge . -5)
                           (cursor . left_ptr)
                           (class . title))

                          ((background . ,border)
                           (left-edge . 0)
                           (right-edge . -1)
                           (bottom-edge . -1)
                           (cursor . left_ptr)
                           (class . bottom-border))

                          ((background . ,border)
                           (right-edge . -1)
                           (top-edge . 0)
                           (bottom-edge . -1)
                           (cursor . left_ptr)
                           (class . right-border))
                          ))

    (shaped-transient-frame `(((background . ,d-top-left)
                               (top-edge . -5)
                               (left-edge . -5)
                               (cursor . left_ptr)
                               (class . title))

                              ((background . ,d-top)
                               (top-edge . -5)
                               (left-edge . 0)
                               (right-edge . 4)
                               (cursor . left_ptr)
                               (class . title))

                              ((background . ,d-top-right)
                               (top-edge . -5)
                               (right-edge . -1)
                               (cursor . left_ptr)
                               (class . title))

                              ((background . ,d-left)
                               (top-edge . 0)
                               (bottom-edge . 4)
                               (left-edge . -5)
                               (cursor . left_ptr)
                               (class . title))

                              ((background . ,d-bottom-left)
                               (bottom-edge . -1)
                               (left-edge . -5)
                               (cursor . left_ptr)
                               (class . title))
                              ))
    )

  (def-frame-class belateral-button '(cursor . left_ptr)
    (bind-keys belateral-button-keymap
      "Button1-Off" 'iconify-window)
    (bind-keys belateral-button-keymap
      "Button3-Off" 'delete-window))

  (add-frame-style 'belateral
   (lambda (w type)
     (case type
           ((default) frame)
           ((transient) transient-frame)
           ((shaped) shaped-frame)
           ((shaped-transient) shaped-transient-frame))))

  (call-after-property-changed '(WM_NAME _NET_WM_NAME) update-title-width)
  )

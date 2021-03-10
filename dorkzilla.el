;;; dorkzilla.el --- A Emacs drum machine with elements of a old roland (R-8?)
;;; and some teenage engineering inspiration for weirdness.

;;; Commentary:
;;

;;; Code:

;;; Emacs on OSX has no sound support. It would have blocked while playing anyway.
;;;
;;; Got this from
;;; https://github.com/killdash9/.emacs.d/blob/master/site-lisp/play-sound.e
;;; Not really production ready, as it starts a process everytime, but it's a start

(eval-when-compile (require 'cl))

(defun play-sound-internal (sound)
  "Internal function for `play-sound' (which see)."
  (or (eq (car-safe sound) 'sound)
      (signal 'wrong-type-argument (list sound)))

  (destructuring-bind (&key file data volume device)
      (cdr sound)

    (and (or data device)
         (error "DATA and DEVICE arg not supported"))

    (apply #'start-process "afplay" nil
           "afplay" (append (and volume (list "-v" volume))
                            (list (expand-file-name file data-directory))))))

(provide 'play-sound)

;; Got some sounds in

;; "/Users/loop/toykeyboards-master/Keys (PSR)/individual drums/"

;; Major mode tipo tracker, ma orizzontale, che permette di scrivere una robba tipo:
;; BD|9...9...9...9...
;; OH|5   5   5   5
;; CH|..3....3..3...3
;; SN|....7.......7..

;; E di fare un 4ttf

;; Il testo deve essere il data model, o li faccio distinti?
;; Se li faccio distinti.. e' una seq (NVoices) di arrays|string di..
(setq bdpattern "9...1...9...1.4.")
(setq ohpattern "5   5   5   5   ")

;; Elemento stringa si setta con aset; E ?6 e' "6"
(aset bdpattern 0 ?6)

;; E si accede fra l'altro con aref se array
(aref bdpattern 0)
;; O elt in quanto sequence
(elt bdpattern 0)

;; The samples
(setq bdsample "/Users/loop/toykeyboards-master/Keys (PSR)/individual drums/PSR_Bassdrum_low.wav")
(setq ohsample "/Users/loop/toykeyboards-master/Keys (PSR)/individual drums/PSR_Highhat_pedal.wav")

(play-sound `(sound :file "/Users/loop/toykeyboards-master/Keys (PSR)/individual drums/PSR_Bassdrum_low.wav" :volume "1"))

;;; This does not work, does not eval bdsample!
(play-sound `(sound :file bdsample :volume "1"))

;;; This does!
(play-sound (list 'sound :file bdsample :volume "1"))

;; So define bd and oh sounds
(setq bdsound (list 'sound :file bdsample))
(setq ohsound (list 'sound :file ohsample))

(play-sound ohsound)

;; Proviamo a usare i record per definire una voce; Una voice ha il nome, il sound e il pattern.
(setq bdvoice (record 'voice "Bass Drum" bdsound bdpattern))
(setq ohvoice (record 'voice "Open Hat" ohsound ohpattern))

;; Access elements of voice records
(defun pattern (voice)
  (aref voice 3))
(defun sound (voice)
  (aref voice 2))
(defun name(voice)
  (aref voice 1))

(pattern ohvoice)
(sound ohvoice)
(name ohvoice)

(defun playvoice (voice idx)
  "Play voice step at index"
  (let ((cur-step (aref (pattern voice) idx)))
    (if (note-p cur-step)
        (progn
          (message (format "playing a %c" cur-step))
          (play-sound (append (sound voice) '(:volume (format "%c" cur-step)))))
      (message "not playing"))))

(playvoice bdvoice 0)

(defun playvoices (voices idx)
  "Play n voices at step at the same time"
  (seq-map (lambda (voice)
             (playvoice voice idx)) voices))


(playvoice bdvoice 0)

(playvoices [bd oh])

(defun play-track (track)
  "Plays a track from start to finish, once"
  (let ((idx 0))
    (message (format "Playo track %s" track))
    (while (< idx 16)
      (message (format "playo idx: %i" idx))
      (playvoice track idx)
      (sit-for 0.1)
      (incf idx))))

(play-track bd)

;; all current timers
(list-timers)

(defun note-p (elt)
  "Is element a note? (0/9)"
  (and (>= elt ?0) (<= elt ?9)))

(defun decreasable (elt)
  "Is element a note which may be decreased?"
  (and (>= elt ?1) (<= elt ?9)))

(defun make-quieter (pattern)
  "Torna un patter piu' quiet. Ma lo sminchia"
  (seq-map (lambda (x)
             (if (decreasable x)
                 (format "%d" (- x 1))
               x)) pattern))
(setq bd "0234")
(setq bd (make-quieter bd))

;; Callback che esegue ogni 16th, almeno inizialmente..
;; E la manda su:
;; Messaggi OSC
;; Messaggi Midi
;; Supercollider?
;; Direct audio? (si puo' fare? si puo' scrivere bytes su un device? boh!)

(message point-min)


(set-buffer "foo")
(print 30)
(set-mark (point-at-bol))
(goto-char (point-at-eol))


(save-current-buffer
  (get-buffer-create "foo")

  (insert-buffer-substring "Dio Canarino!")
  (set-mark (point-at-bol))
  (goto-char (point-at-eol)))


(setq foo (make-overlay 1 10))
(point-at-eol)

(defun xah-make-overlay-bold-region (@begin @end)
  "Make the region bold, using overlay.
Version 2016-11-01"
  (interactive "r")
  (progn
    (overlay-put (make-overlay @begin @end) 'background-color "#000000")
    (setq mark-active nil )))

(xah-make-overlay-bold-region 20 300)
(inverse-video)
(marker-position 23)

(mark-beginning-of-buffer)

(mark-end-of-buffer)
(overlay-put (make-overlay (point) (point)) 'before-string "Hi there!")






(overlay-put (make-overlay (point) (point)) 'line-prefix "diocane!")



(while (progn
         (forward-line 1)
         (not (looking-at "^$"))))
(while (forward-line 1)
(progn
       (with-output-to-string
         (princ "Faccio")
         (princ (point-at-bol)))
         (xah-make-overlay-bold-region (point-at-bol) (point-at-eol))
         (sleep-for 1)))


(buffer-name)

(generate-new-buffer-name "foo")

(read-event)

(make-xwidget nil)

(insert-text-button "DioCane")DioCane

(buffer-list)



;;(provide 'robba)

;;; robba.el ends here


;; This gives an introduction to Emacs Lisp in 15 minutes (v0.2d)
;;
;; Author: Bastien / @bzg2 / https://bzg.fr
;;
;; First make sure you read this text by Peter Norvig:
;; http://norvig.com/21-days.html
;;
;; Then install GNU Emacs 24.3:
;;
;; Debian: apt-get install emacs (or see your distro instructions)
;; MacOSX: http://emacsformacosx.com/emacs-builds/Emacs-24.3-universal-10.6.8.dmg
;; Windows: http://ftp.gnu.org/gnu/windows/emacs/emacs-24.3-bin-i386.zip
;;
;; More general information can be found at:
;; http://www.gnu.org/software/emacs/#Obtaining

;; Important warning:
;;
;; Going through this tutorial won't damage your computer unless
;; you get so angry that you throw it on the floor.  In that case,
;; I hereby decline any responsability.  Have fun!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Fire up Emacs.
;;
;; Hit the `q' key to dismiss the welcome message.
;;
;; Now look at the gray line at the bottom of the window:
;;
;; "*scratch*" is the name of the editing space you are now in.
;; This editing space is called a "buffer".
;;
;; The scratch buffer is the default buffer when opening Emacs.
;; You are never editing files: you are editing buffers that you
;; can save to a file.
;;
;; "Lisp interaction" refers to a set of commands available here.
;;
;; Emacs has a built-in set of commands available in every buffer,
;; and several subsets of commands available when you activate a
;; specific mode.  Here we use the `lisp-interaction-mode', which
;; comes with commands to evaluate and navigate within Elisp code.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Semi-colons start comments anywhere on a line.
;;
;; Elisp programs are made of symbolic expressions ("sexps"):
(+ 2 2)

;; This symbolic expression reads as "Add 2 to 2".

;; Sexps are enclosed into parentheses, possibly nested:
(+ 2 (+ 1 1))

;; A symbolic expression contains atoms or other symbolic
;; expressions.  In the above examples, 1 and 2 are atoms,
;; (+ 2 (+ 1 1)) and (+ 1 1) are symbolic expressions.

;; From `lisp-interaction-mode' you can evaluate sexps.
;; Put the cursor right after the closing parenthesis then
;; hold down the control and hit the j keys ("C-j" for short).

(+ 3 (+ 1 2))
;;           ^ cursor here
;; `C-j' => 6
(split-window)
;; `C-j' inserts the result of the evaluation in the buffer.
(display-buffer-in-side-window (current-buffer) '(side left))2
;; `C-x C-e' displays the same result in Emacs bottom line,
;; called the "minibuffer".  We will generally use `C-x C-e',
;; as we don't want to clutter the buffer with useless text.

;; `setq' stores a value into a variable:
(setq my-name "Bastien")
;; `C-x C-e' => "Bastien" (displayed in the mini-buffer)

;; `insert' will insert "Hello!" where the cursor is:
(insert "Hello!")
;; `C-x C-e' => "Hello!"

;; We used `insert' with only one argument "Hello!", but
;; we can pass more arguments -- here we use two:

(insert "Hello" " world!")
;; `C-x C-e' => "Hello world!"

;; You can use variables instead of strings:
(insert "Hello, I am " my-name)
;; `C-x C-e' => "Hello, I am Bastien"

;; You can combine sexps into functions:
(defun hello () (insert "Hello, I am " my-name))
;; `C-x C-e' => hello

;; You can evaluate functions:
(hello)
;; `C-x C-e' => Hello, I am Bastien

;; The empty parentheses in the function's definition means that
;; it does not accept arguments.  But always using `my-name' is
;; boring, let's tell the function to accept one argument (here
;; the argument is called "name"):

(defun hello (name) (insert "Hello " name))
;; `C-x C-e' => hello

;; Now let's call the function with the string "you" as the value
;; for its unique argument:
(hello "you")
;; `C-x C-e' => "Hello you"

;; Yeah!

;; Take a breath.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Now switch to a new buffer named "*test*" in another window:

(switch-to-buffer-other-window "*test*")
;; `C-x C-e'
;; => [screen has two windows and cursor is in the *test* buffer]

;; Mouse over the top window and left-click to go back.  Or you can
;; use `C-x o' (i.e. hold down control-x and hit o) to go to the other
;; window interactively.

;; You can combine several sexps with `progn':
(progn
  (switch-to-buffer-other-window "*test*")
  (hello "you"))
;; `C-x C-e'
;; => [The screen has two windows and cursor is in the *test* buffer]

;; Now if you don't mind, I'll stop asking you to hit `C-x C-e': do it
;; for every sexp that follows.

;; Always go back to the *scratch* buffer with the mouse or `C-x o'.

;; It's often useful to erase the buffer:
(progn
  (switch-to-buffer-other-window "*test*")
  (erase-buffer)
  (hello "there"))

;; Or to go back to the other window:
(progn
  (switch-to-buffer-other-window "*test*")
  (erase-buffer)
  (hello "diocane")
  (other-window 1))

;; You can bind a value to a local variable with `let':
(let ((local-name "me"))
  (switch-to-buffer-other-window "*test*")
  (erase-buffer)
  (hello local-name)
  (other-window 1))

;; No need to use `progn' in that case, since `let' also combines
;; several sexps.

;; Let's format a string:
(format "Hello %s!\n" "visitor")

;; %s is a place-holder for a string, replaced by "visitor".
;; \n is the newline character.

;; Let's refine our function by using format:
(defun hello (name)
  (insert (format "Hello %s!\n" name)))

(hello "you")

;; Let's create another function which uses `let':
(defun greeting (name)
  (let ((your-name "Bastien"))
    (insert (format "Hello %s!\n\nI am %s."
                    name       ; the argument of the function
                    your-name  ; the let-bound variable "Bastien"
                    ))))

;; And evaluate it:
(greeting "you")

;; Some function are interactive:
(read-from-minibuffer "Enter your name: ")

;; Evaluating this function returns what you entered at the prompt.

;; Let's make our `greeting' function prompt for your name:
(defun greeting (from-name)
  (let ((your-name (read-from-minibuffer "Enter your name: ")))
    (insert (format "Hello!\n\nI am %s and you are %s."
                    from-name ; the argument of the function
                    your-name ; the let-bound var, entered at prompt
                    ))))

(greeting "Bastien")

;; Let's complete it by displaying the results in the other window:
(defun greeting (from-name)
  (let ((your-name (read-from-minibuffer "Enter your name: ")))
    (switch-to-buffer-other-window "*test*")
    (erase-buffer)
    (insert (format "Hello %s!\n\nI am %s." your-name from-name))
    (other-window 1)))

;; Now test it:
(greeting "Bastien")

;; Take a breath.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Let's store a list of names:
(setq list-of-names '("Sarah" "Chloe" "Mathilde"))

;; Get the first element of this list with `car':
(car list-of-names)

;; Get a list of all but the first element with `cdr':
(cdr list-of-names)

;; Add an element to the beginning of a list with `push':
(push "Stephanie" list-of-names)

;; NOTE: `car' and `cdr' don't modify the list, but `push' does.
;; This is an important difference: some functions don't have any
;; side-effects (like `car') while others have (like `push').

;; Let's call `hello' for each element in `list-of-names':
(mapcar 'hello list-of-names)

;; Refine `greeting' to say hello to everyone in `list-of-names':
(defun greeting ()
    (switch-to-buffer-other-window "*test*")
    (erase-buffer)
    (mapcar 'hello list-of-names)
    (other-window 1))

(greeting)

;; Remember the `hello' function we defined above?  It takes one
;; argument, a name.  `mapcar' calls `hello', successively using each
;; element of `list-of-names' as the argument for `hello'.

;; Now let's arrange a bit what we have in the displayed buffer:

(defun replace-hello-by-bonjour ()
    (switch-to-buffer-other-window "*test*")
    (goto-char (point-min))
    (while (search-forward "Hello")
      (replace-match "Bonjour"))
    (other-window 1))

;; (goto-char (point-min)) goes to the beginning of the buffer.
;; (search-forward "Hello") searches for the string "Hello".
;; (while x y) evaluates the y sexp(s) while x returns something.
;; If x returns `nil' (nothing), we exit the while loop.

(replace-hello-by-bonjour)

;; You should see all occurrences of "Hello" in the *test* buffer
;; replaced by "Bonjour".

;; You should also get an error: "Search failed: Hello".
;;
;; To avoid this error, you need to tell `search-forward' whether it
;; should stop searching at some point in the buffer, and whether it
;; should silently fail when nothing is found:

;; (search-forward "Hello" nil t) does the trick:

;; The `nil' argument says: the search is not bound to a position.
;; The `t' argument says: silently fail when nothing is found.

;; We use this sexp in the function below, which doesn't throw an error:

(defun hello-to-bonjour ()
    (switch-to-buffer-other-window "*test*")
    (erase-buffer)
    ;; Say hello to names in `list-of-names'
    (mapcar 'hello list-of-names)
    (goto-char (point-min))
    ;; Replace "Hello" by "Bonjour"
    (while (search-forward "Hello" nil t)
      (replace-match "Bonjour"))
    (other-window 1))

(hello-to-bonjour)

;; Let's colorize the names:

(defun boldify-names ()
    (switch-to-buffer-other-window "*test*")
    (goto-char (point-min))
    (while (re-search-forward "Bonjour \\(.+\\)!" nil t)
      (add-text-properties (match-beginning 1)
                           (match-end 1)
                           (list 'face 'bold)))
    (other-window 1))

;; This functions introduces `re-search-forward': instead of
;; searching for the string "Bonjour", you search for a pattern,
;; using a "regular expression" (abbreviated in the prefix "re-").

;; The regular expression is "Bonjour \\(.+\\)!" and it reads:
;; the string "Bonjour ", and
;; a group of           | this is the \\( ... \\) construct
;;   any character      | this is the .
;;   possibly repeated  | this is the +
;; and the "!" string.

;; Ready?  Test it!

(boldify-names)
nil

;; `add-text-properties' adds... text properties, like a face.

;; OK, we are done.  Happy hacking!

;; If you want to know more about a variable or a function:
;;
;; C-h v a-variable RET
;; C-h f a-function RET
;;
;; To read the Emacs Lisp manual with Emacs:
;;
;; C-h i m elisp RET
;;
;; To read an online introduction to Emacs Lisp:
;; https://www.gnu.org/software/emacs/manual/html_node/eintr/index.html


(getenv "SHELL")
(getenv "PATH")

(insert (shell-command-to-string "ls -lR"))

(defun cicla ()
  (move-to-window-line 0)
  (let ((my-over (make-overlay (point-at-bol) (point-at-eol))))
    (overlay-put my-over 'face 'bold)
    ;;(overlay-put my-over 'face 'shadow)
    ;;(message (format "beg: %i, end: %i" (point-at-bol) (point-at-eol)))
    (while (eq 1 (vertical-motion 1))
      ;;(message "ancora!")
      (sit-for 0 30)
      (move-overlay my-over (point-at-bol) (point-at-eol)))
    (delete-overlay my-over)))

;;    (while (eq 1 (vertical-motion 1))
      ;;      (move-overlay my-over (point-at-bol) (point-at-eol)))))
      ;;)))

t
(point-at-bol)
(momentary-string-display "fiooo" 12205)
(cicla)

dslkjfdl

sdflkjfasl

(let
    ((a 23)
     (b 33)
     (c (+ a b))
     )
  (momentary-string-display c))

(defvar parameters
  '(window-parameters . ((no-other-window . t)
                         (no-delete-other-windows . t))))

(setq fit-window-to-buffer-horizontally t)
(setq window-resize-pixelwise t)

(setq
 display-buffer-alist
 `(("\\*Buffer List\\*" display-buffer-in-side-window
    (side . top) (slot . 0) (window-height . fit-window-to-buffer)
    (preserve-size . (nil . t)) ,parameters)
   ("\\*Tags List\\*" display-buffer-in-side-window
    (side . right) (slot . 0) (window-width . fit-window-to-buffer)
    (preserve-size . (t . nil)) ,parameters)
   ("\\*\\(?:help\\|grep\\|Completions\\)\\*"
    display-buffer-in-side-window
    (side . bottom) (slot . -1) (preserve-size . (nil . t))
    ,parameters)
   ("\\*\\(?:shell\\|compilation\\)\\*" display-buffer-in-side-window
    (side . bottom) (slot . 1) (preserve-size . (nil . t))
    ,parameters)))

;; Quasi! come si fanno i range? come andare da 0.0 a 100 in steps di 0.1?
;; come settare la var dello scroll di questo step invece di aspettare di
;; finire la lista?x
(let ((slist '(0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1
                   1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8)))
  (while t
    (set-window-vscroll (selected-window) (pop slist))
  (sit-for 0.04)))

(window-vscroll)

(set-window-vscroll (selected-window) 10.4)
0.07142857142857142

;; Fico, move to focus!
(setq mouse-autoselect-window nil)

(window-parameters)
((ses--mode-line-process A2 " cell " "A2") (ses--curcell-overlay . #<overlay from 54 to 69 in test.ses>) (cursor-intangible--last-point . 54) (quit-restore window window #<window 3 on robba.el> #<buffer *helm-mode-find-file-read-only*>) (no-other-window) (internal-region-overlay . #<overlay in no buffer>))

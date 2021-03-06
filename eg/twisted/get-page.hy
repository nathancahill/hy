;; To run this example, do the following:
;;      $ hy get-page.hy http://docs.hylang.org/en/latest/
;;
;; At which point, you should see output like this:
;;      2013-06-24 23:03:57-0700 [-] Log opened.
;;      2013-06-24 23:03:57-0700 [-] Starting factory <HTTPClientFactory: http://docs.hylang.org/en/latest/>
;;      2013-06-24 23:03:57-0700 [HTTPPageGetter,client] Byte count for the content of the HTTP page passed: 11835
;;      2013-06-24 23:03:57-0700 [HTTPPageGetter,client] Preparing to stop reactor ...
;;      2013-06-24 23:03:57-0700 [HTTPPageGetter,client] Stopping factory <HTTPClientFactory: http://docs.hylang.org/en/latest/>
;;      2013-06-24 23:03:57-0700 [-] Main loop terminated.
(import sys)

(import [twisted.web.client [getPage]]
        [twisted.internet [reactor]]
        [twisted.python [log]])

(defun get-page-size (result)
  (print
    (+ "Byte count for the content of the HTTP page passed: "
       (str (len result)))))

(defun log-error (err)
  (log.msg err))

(defun finish (ignore)
  (log.msg "Preparing to stop reactor ...")
  (reactor.stop))

(defun get-page (url)
  (let ((d (getPage url)))
    (d.addCallback get-page-size)
    (d.addErrback log-error)
    (d.addCallback finish)))

(defun caddr (list)
  ; This is how you'd do this in CL:
  ;(car (cdr (cdr list))))
  ; However, I think this is more efficient in hy:
  (get list 2))

(if (= __name__ "__main__")
  (do
    (log.startLogging sys.stdout)
    (get-page (caddr sys.argv))
    (reactor.run)))

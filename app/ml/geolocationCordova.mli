(* -------------------------------------------------------------------------- *)
type watch_id
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
(* FIXME
 * All types are set to 'a Js.opt because during tests (nexus 5, android 6.0.1),
 * some values were null and where sent to null.
 * Use Js.Opt.to_option c##prop to convert to option type and match ... with.
 * See the example.
 * AltitudeAccuracy: not supported on android devices and Amazon Fire OS. Set
 * null in these cases.
 *)
type coordinates =
  <
    latitude            : float Js.opt Js.readonly_prop ;
    longitude           : float Js.opt Js.readonly_prop ;
    altitude            : float Js.opt Js.readonly_prop ;
    accuracy            : float Js.opt Js.readonly_prop ;
    altitudeAccuracy    : float Js.opt Js.readonly_prop ;
    heading             : float Js.opt Js.readonly_prop ;
    speed               : float Js.opt Js.readonly_prop
  > Js.t

(* A timestamp is just an integer *)
type position =
  <
    coords              : coordinates Js.readonly_prop ;
    timestamp           : int Js.readonly_prop
  > Js.t
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
(* Types and functions related to errors *)
(* position_error contains a properties called 'code' which is a 1 2 or 3 ie a
 * int. For the binding, we need to use an integer but we provide a
 * position_error type and a function taking the integer returned by the error
 * whic returns the corresping value for the ocaml type. *)
type position_error_code
val position_error_code_to_value : int -> position_error_code

type position_error =
  <
    code      : int Js.readonly_prop ;
    message   : Js.js_string Js.t Js.readonly_prop
  > Js.t
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
type options =
  <
    enableHighAccuracy        : bool Js.readonly_prop ;
    timeout                   : int Js.readonly_prop ;
    maximumAge                : int Js.readonly_prop
  > Js.t

val create_options :  ?enable_high_accuracy:bool ->
                      ?timeout:int ->
                      ?maximum_age:int ->
                      unit -> options
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
class type geolocation =
  object
    method getCurrentPosition : (position -> unit) ->
                                (position_error -> unit) ->
                                options -> unit Js.meth
    method watchPosition      : (position -> unit) ->
                                (position_error -> unit) ->
                                options -> watch_id Js.meth
    method clearWatch         : watch_id -> unit Js.meth
  end
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
val geolocation : unit -> geolocation Js.t
(* -------------------------------------------------------------------------- *)

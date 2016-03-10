let doc = Dom_html.document

let convert nb =
  let nb_opt = Js.Opt.to_option nb in
  match nb_opt with
  | None -> string_of_int 0
  | Some x -> string_of_float x

let create_paragraph str =
  let p = Dom_html.createP doc in
  p##.innerHTML := Js.string str;
  p

let on_device_ready _ =
  let geo = GeolocationCordova.geolocation () in
    let id : GeolocationCordova.watch_id = geo##watchPosition
  (fun (position : GeolocationCordova.position) ->
    let c = position##.coords in
    let time = position##.timestamp in
    Dom.appendChild doc##.body
      (create_paragraph ("Latitude: " ^ (convert c##.latitude)));
    Dom.appendChild doc##.body
      (create_paragraph ("Longitude: " ^ (convert c##.longitude)));
    Dom.appendChild doc##.body
      (create_paragraph ("Altitude: " ^ (convert c##.altitude)));
    Dom.appendChild doc##.body
      (create_paragraph ("Accuracy: " ^ (convert c##.accuracy)));
    Dom.appendChild doc##.body
      (create_paragraph ("Heading: " ^ (convert c##.heading)))
  )
  (fun (error : GeolocationCordova.position_error) ->
    Dom_html.window##(alert error##.message)
  )
  (GeolocationCordova.create_options ()) in
  let button = Dom_html.createButton doc in
  button##.innerHTML := Js.string "Stop";
  Lwt.async
  ( fun () ->
    Lwt_js_events.clicks button
    ( fun _ev _thread -> geo##(clearWatch id); Lwt.return ())
  );
  Dom.appendChild doc##.body button;
  Js._false

let _ =
  Dom.addEventListener Dom_html.document (Dom.Event.make "deviceready")
  (Dom_html.handler on_device_ready) Js._false

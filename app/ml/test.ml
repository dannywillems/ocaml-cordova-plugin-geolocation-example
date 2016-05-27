let doc = Dom_html.document

let data_to_str nb =
  match nb with
  | None -> "0"
  | Some x -> string_of_float x

let create_paragraph str =
  let p = Dom_html.createP doc in
  p##.innerHTML := Js.string str;
  p

let on_device_ready () =
  let geo = Cordova_geolocation.t () in
  let id = geo#watch_position
    (fun position ->
      let c = position#coords in
      let time = position#timestamp in
      Dom.appendChild doc##.body
        (create_paragraph ("Latitude: " ^ (data_to_str c#latitude)));
      Dom.appendChild doc##.body
        (create_paragraph ("Longitude: " ^ (data_to_str c#longitude)));
      Dom.appendChild doc##.body
        (create_paragraph ("Altitude: " ^ (data_to_str c#altitude)));
      Dom.appendChild doc##.body
        (create_paragraph ("Accuracy: " ^ (data_to_str c#accuracy)));
      Dom.appendChild doc##.body
        (create_paragraph ("Heading: " ^ (data_to_str c#heading)));
      Dom.appendChild doc##.body
        (create_paragraph ("Time: " ^ (data_to_str (Some (float_of_int time)))));
      Dom.appendChild doc##.body (create_paragraph "------------------------")
    )
    (fun error ->
      Dom_html.window##(alert (Js.string error#message))
    )
    (Cordova_geolocation.create_options ())
  in
  let button = Dom_html.createButton doc in
  button##.innerHTML := Js.string "Stop";
  Lwt.async
  ( fun () ->
    Lwt_js_events.clicks button
    ( fun _ev _thread -> geo#clear_watch id; Lwt.return ())
  );
  Dom.appendChild doc##.body button

let _ = Cordova.Event.device_ready on_device_ready

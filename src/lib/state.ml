(* Mutable State *)
let tasks = Task_tree.make ()

let add_tasks (id, parent_id, domain, ts, kind) =
  let task =
    Task.create ~id ~domain ~parent_id
      (Runtime_events.Timestamp.to_int64 ts)
      kind
  in
  Task_tree.add tasks task

let update_loc i loc =
  Task_tree.update tasks i (fun t -> { t with Task.loc = loc :: t.loc })

let update_logs i logs =
  Task_tree.update tasks i (fun t -> { t with Task.logs = logs :: t.logs })

let update_name i name =
  Task_tree.update tasks i (fun t -> { t with Task.name = name :: t.name })

let switch_to ~id ~domain ts =
  Task_tree.update_active tasks ~id (Runtime_events.Timestamp.to_int64 ts)

let set_parent ~child ~parent = Task_tree.set_parent tasks ~child ~parent

let resolved v ts =
  Task_tree.update tasks v (fun t ->
      { t with status = Resolved (Runtime_events.Timestamp.to_int64 ts) })

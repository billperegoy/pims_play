# PimsPlay

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `pims_play` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:pims_play, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/pims_play](https://hexdocs.pm/pims_play).


# PIMS flow
## PVL
*  There is a queue of visit_pims_id. This queue is a cache
   (@ezyvet_invoice_queue)
 (what puts data in here)

* The scheduler runs this task every 10 seconds
    Instinct.Scheduler.Task.EzyVetInvoice.run()
    Instinct.PIMS.process_ezyvet_invoice()
    Source.EzyVet.Sync.PVL.run()

* THis will get 1 visit_pims_id out of the queue and call `maybe_refresh_pvl`
  If the queue is empty, it will refill the queue by re-fetching the list of
  visit_pims_ids

* `maybe_refresh_pvl` will check the timestamp of the pvl data for that visit_id
  If it is expired, it will refresh it from the API. Otherwise it uses the
  cached version if it exists.

* Refreshing the pvl for a visit will get all line items for that appointment.


## Census
* THis runs every 2 minutes.
* It runs process_checkins() and process_checkouts()
* THis will get the list of visits from the PIMS and create the visits in ITP if
  it doesn't exist


# MNew PIMS Flow
## PVL
* Maintain a list of active visit_ids in state
* API functions to add and delete visi_ids. These willbe called during
  checkin/chckout
* Use  cache to store the retrived pvl line_items
* A new visit should send a message to the PIMS API to fetch that PVL
* We should look at the age of each cacahe item and refresh when it reaches a
  certain age. We could poll or store a `settimeout` function that does t
  automatically.

  Could we do something like this:
  https://stackoverflow.com/questions/43892784/what-are-the-equivalent-of-settimeout-and-setinterval-in-elixir


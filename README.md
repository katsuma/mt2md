# mt2md

`mt2md` fetches MovableType entries with categories from database and exports them by markdown file.
`mt2md` uses only these tables.

- mt_entry
- mt_catrgoy
- mt_placement

If you need more table data, send your pull request.


## Install

```
bundle
```

## Run

```
bundle exec ruby mt2md.rb
```

## License
`mt2md` is released under the MIT License.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

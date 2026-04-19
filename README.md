# shadcn-rb example

Demo + docs site for [`shadcn-rb`](https://github.com/accountaim/shadcn-rb).

## What installing the gem adds to your app

`main` is kept at exactly 4 commits so every layer of adoption is one diff:

- [`harness...adopt-patch`](https://github.com/AccountAim/shadcn-rb-example/compare/harness...adopt-patch) — what you change in your Gemfile + compose + installer output. This is the adoption diff.
- [`adopt-patch...demo-content`](https://github.com/AccountAim/shadcn-rb-example/compare/adopt-patch...demo-content) — this repo's docs site on top. Not part of adoption.

## Run

```
just start
```

Needs Docker and [`just`](https://github.com/casey/just) — plus a sibling `../shadcn-rb` checkout if you're developing the gem locally. Site comes up at <http://localhost:4000>.

## License

MIT — see [LICENSE](./LICENSE).

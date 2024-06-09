# RATEBEER

### Prerequisites

```
ruby 3.1.2
rails 7.0.8.3
```

### Installation

- Get a [bm_key](https://beermapping.com/api/reference)
- Get a [ws_key](https://weatherstack.com/documentation)

- Install gems
```
gem install bundler
bundle install
```

- Init DB
```
rails db:migrate
```

- Init server
```
BEERMAPPING_APIKEY="bm_key" WEATHERSTACK_APIKEY="ws_key" rails s
```

### Run test

```
rspec -fd spec
```

### Run linter

```
rubocop
```

### Deploy to [Fly](https://fly.io/)

```
fly deploy
```
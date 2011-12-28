## Redis.yml

Generates a redis.yml file inside /data/#{app_name}/shared/config/redis for each application on the environment. The redis.yml points to the default location of redis on EY Cloud (the db master).

### How to parse the redis.yml

    config = YAML.load_file(Rails.root.join('config/redis.yml'))[Rails.env].symbolize_keys
    $redis = Redis.new(config)
FROM jiting/rails-base-builder:latest AS Builder

FROM jiting/rails-base-production:latest

USER app

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
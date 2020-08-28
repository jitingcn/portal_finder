FROM jiting/rails-base:builder-latest AS Builder

FROM jiting/rails-base:production-latest

RUN apk add --no-cache libjpeg libpng imagemagick

USER app

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
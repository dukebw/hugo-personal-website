#!/bin/bash

# A bash script that helps me create notes for my website.

HOSTING_REPO="$HOME/work/personal-website/"
HUGO_REPO="$HOME/work/hugo-personal-website"

# Check the value of the first parameter
case "$1" in
reset)
  rm -rf "$HUGO_REPO/public"
  cd "$HUGO_REPO" || exit
  hugo
  hugo server --disableFastRender
  ;;

pub)
  # Ask for commit message, rebuild the site, push to blog repo, then push to
  # hosting repo.
  read -p "Enter commit message: " commitmessage

  read -p "Would you like to tweet + toot that? (y/n) " will_tweet

  if [[ $will_tweet == [Yy]* ]]; then
    read -p "Enter tags, or press enter to post without tags: " tags
  fi

  cd "$HUGO_REPO" || exit
  rm -rf "$HUGO_REPO/public"
  hugo
  git add .
  git commit -m "$commitmessage"
  git push
  rm -rf "$HOSTING_REPO*"
  cp -r "$HUGO_REPO"/public/* "$HOSTING_REPO"
  cd "$HOSTING_REPO" || exit
  git add .
  git commit -m "$commitmessage"
  git push

  if [[ $will_tweet == [Yy]* ]]; then
    echo "Waiting 10 seconds to allow it to publish before tweeting."
    sleep 10

    # Post to twitter/mastodon without tags.
    if [[ $tags == "" ]]; then
      tweet
      toot
      exit
    fi

    tweet "$tags"
    toot "$tags"
  fi
  ;;

"")
  # Change to the websites/blog directory if no argument was given
  cd "$HUGO_REPO" || exit
  ;;

*)
  # Print an error message if the parameter was not "zet" or "article"
  echo "Error: Invalid parameter. Usage: blog zet|article|pub"
  ;;
esac

alias SprintNameGenerator.Repo
alias SprintNameGenerator.Model.Corpus

alias Markov.Dictionary

love_sonet_18 = """
Shall I compare thee to a summer's day?
Thou art more lovely and more temperate:
Rough winds do shake the darling buds of May,
And summer's lease hath all too short a date:
Sometime too hot the eye of heaven shines,
And often is his gold complexion dimm'd;
And every fair from fair sometime declines,
By chance or nature's changing course untrimm'd;
But thy eternal summer shall not fade
Nor lose possession of that fair thou owest;
Nor shall Death brag thou wander'st in his shade,
When in eternal lines to time thou growest:
So long as men can breathe or eyes can see,
So long lives this and this gives life to thee.
"""

dictionary = Dictionary.new(love_sonet_18, name: "Love Sonet 18")

Repo.delete_all(Corpus)

dictionary
|> Corpus.from
|> Repo.insert!

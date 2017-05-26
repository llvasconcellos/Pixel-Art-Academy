AB = Artificial.Babel

Meteor.publish 'Artificial.Babel.Translation', (namespace, keyOrKeys, languages) ->
  check namespace, String
  check keyOrKeys, Match.OptionalOrNull Match.OneOf String, [String]
  check languages, Match.OptionalOrNull [String]

  query =
    namespace: namespace

  query.key = keyOrKeys if _.isString keyOrKeys
  query.key = $in: keyOrKeys if _.isArray keyOrKeys

  AB.Translation.documents.find query,
    fields: generateFieldsForLanguages languages

Meteor.publish 'Artificial.Babel.Translation.withId', (translationId, languages) ->
  check translationId, Match.DocumentId
  check languages, Match.OptionalOrNull [String]

  AB.Translation.documents.find
    _id: translationId
  ,
    fields: generateFieldsForLanguages languages

generateFieldsForLanguages = (languages) ->
  fields =
    namespace: 1
    key: 1
    best: 1

  if languages?
    # Make all languages lowercase.
    languages = _.map languages, _.toLower

    minimalLanguages = []

    # Construct the minimal required language set by removing subsets (for example 'en' already includes 'en-US').
    for language in languages
      redundant = false

      # Compare to all the other languages.
      for otherLanguage in _.without languages, language
        # If this language is contained within the other language, we don't need it.
        redundant = true if _.startsWith language, otherLanguage

      minimalLanguages.push language unless redundant

    for language in minimalLanguages
      # Change language dash into subdocument notation.
      field = "translations.#{language.toLowerCase().replace '-', '.'}"
      fields[field] = 1

  else
    # Include all languages.
    fields.translations = 1

  fields

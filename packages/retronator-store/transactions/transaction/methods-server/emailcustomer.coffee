RS = Retronator.Store
AT = Artificial.Telepathy

RS.Transactions.Transaction.emailCustomer = ({customer, payments, shoppingCart}) ->
  unless customer.email
    # We don't have user's email, so we can't send them the email (for example, if they logged in with Twitter only).
    # Exception is not thrown so that the method completes, but we can't continue with emailing.
    console.warning "Email was not sent for customer", customer, "payments", payments, "shoppingCart", shoppingCart
    return

  email = new AT.EmailComposer
  
  if customer.name
    email.addParagraph "Hey #{customer.name},"

  else
    email.addParagraph "Hey,"

  itemNamesList = for cartItem in shoppingCart.items()
    cartItem.item.name.refresh().translate().text

  email.addParagraph "We have received your purchase order for:\n
                      #{itemNamesList.join '\n'}"

  email.addParagraph "Thank you so much for you tip of $#{shoppingCart.tipAmount()} as well!" if shoppingCart.tipAmount()

  for payment in payments
    switch payment.type
      when RS.Transactions.Payment.Types.StripePayment
        email.addParagraph "At this point your credit card was only authorized. We will
                            collect the purchase price of $#{payment.amount} when the game's first gameplay chapter
                            releases later this year. You will be emailed beforehand in case you need to cancel
                            your purchase at that time."

      when RS.Transactions.Payment.Types.StoreCredit
        email.addParagraph "We #{if payments.length > 1 then "also " else ""}applied your store credit of $#{payment.storeCreditAmount} towards the purchase."

  email.addParagraph "Thank you so much for your order!"
  
  email.addParagraph "Best,\n
                      Matej 'Retro' Jan // Retronator"
  
  email.addParagraph "p.s. We have a secret Facebook group for the game. If you want
                      to join, just reply and let me know the email you use for Facebook
                      and I'll send you an invite."

  email.addParagraph "p.p.s. Development blog for the game is on Patreon. If you go to the
                      overview page you can click Follow to get email updates (no pledge needed,
                      it's all public)."

  email.addLinkParagraph 'https://www.patreon.com/retro/posts?tag=Pixel%20Art%20Academy', "Patreon development blog"

  email.addParagraph "p.p.p.s. There is a lo-fi prototype of the drawing activities available
                      in the form of articles in Retronator Magazine. Currently it's a hidden
                      draft, but it already has a ton of knowledge and 50 tasks to complete.
                      You can start learning at:"

  email.addLinkParagraph 'https://medium.com/retronator-magazine/pixel-art-academy-study-guide-3ae5f772a83a', "Pixel Art Academy Study Guide"

  email.end()
  
  Email.send
    from: "hi@retronator.com"
    to: customer.email
    subject: "Retronator Store Purchase Confirmation"
    text: email.text
    html: email.html

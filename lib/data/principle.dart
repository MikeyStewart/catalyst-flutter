enum Principle {
  RadicalInclusion,
  Gifting,
  Decommodification,
  RadicalSelfReliance,
  RadicalSelfExpression,
  CommunalEffort,
  CivicResponsibility,
  LeavingNoTrace,
  Participation,
  Immediacy,
}

extension PrincipleExtension on Principle {
  String get displayName {
    switch (this) {
      case Principle.RadicalInclusion:
        return "Radical Inclusion";
      case Principle.Gifting:
        return "Gifting";
      case Principle.Decommodification:
        return "Decommodification";
      case Principle.RadicalSelfReliance:
        return "Radical Self-reliance";
      case Principle.RadicalSelfExpression:
        return "Radical Self-expression";
      case Principle.CommunalEffort:
        return "Communal Effort";
      case Principle.CivicResponsibility:
        return "Civic Responsibility";
      case Principle.LeavingNoTrace:
        return "Leaving No Trace";
      case Principle.Participation:
        return "Participation";
      case Principle.Immediacy:
        return "Immediacy";
    }
  }

  String get description {
    switch (this) {
      case Principle.RadicalInclusion:
        return "Anyone may be a part of Burning Man. We welcome and respect the stranger. No prerequisites exist for participation in our community.";
      case Principle.Gifting:
        return "Burning Man is devoted to acts of gift giving. The value of a gift is unconditional. Gifting does not contemplate a return or an exchange for something of equal value.";
      case Principle.Decommodification:
        return "In order to preserve the spirit of gifting, our community seeks to create social environments that are unmediated by commercial sponsorships, transactions, or advertising. We stand ready to protect our culture from such exploitation. We resist the substitution of consumption for participatory experience.";
      case Principle.RadicalSelfReliance:
        return "Burning Man encourages the individual to discover, exercise and rely on his or her inner resources.";
      case Principle.RadicalSelfExpression:
        return "Radical self-expression arises from the unique gifts of the individual. No one other than the individual or a collaborating group can determine its content. It is offered as a gift to others. In this spirit, the giver should respect the rights and liberties of the recipient.";
      case Principle.CommunalEffort:
        return "Our community promotes social interaction through collective acts of gifting. We value creative cooperation and collaboration. We strive to produce, promote and protect social networks, public spaces, works of art, and methods of communication that support such interaction.";
      case Principle.CivicResponsibility:
        return "We value civil society. Community members who organise events should assume responsibility for public welfare and endeavour to communicate civic responsibilities to participants. Organisers must also assume responsibility for abiding by national law and district bylaws.";
      case Principle.LeavingNoTrace:
        return "Our community respects the environment. We are committed to leaving no physical trace of our activities wherever we gather. We clean up after ourselves and endeavor, whenever possible, to leave such places in a better condition than when we found them.";
      case Principle.Participation:
        return "Our community is committed to a radically participatory ethic. We believe that transformative change, whether in the individual or in society, can occur only through the medium of deeply personal participation in experience. We achieve being through doing. Everyone is invited to work. Everyone is invited to play. We make the world real through actions that open the heart.";
      case Principle.Immediacy:
        return "Immediate experience is, in many ways, the most important touchstone of value in our culture. We seek to overcome barriers that stand between us and a recognition of our inner selves, appreciation of the reality of those around us, participation in society, and contact with a natural world exceeding human powers. No idea can substitute for this experience.";
    }
  }
}

export class UserCredentials {

  public userAdmin = () => {
    return {
      userName: 'userAdmin',
      password: 'password'
    };
  }

  public userAdminOnly = () => {
    return {
      userName: 'adminOnly',
      password: 'password'
    };
  }

  public userStandard = () => {
    return {
      userName: 'userStandard',
      password: 'password'
    };
  }

  public userRestrictions = () => {
    return {
      userName: 'userRestrictions',
      password: 'password'
    };
  }

  public userScheduleMatching = () => {
    return {
      userName: 'userScheduleMatching',
      password: 'password'
    };
  }

  public userUnknown = () => {
    return {
      userName: 'userUnknown',
      password: 'password'
    };
  }
}

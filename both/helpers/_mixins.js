_.mixin({
  /***
   * isValid - indicates if the arguments are not undefined or null
   *   usage - _.isValid(a, b, c)
   *   returns true if a, b, and c are not undefined or null
   * @returns {Boolean}
   */
  isValid: function () {
    var isValid = true; //assume everything is valid
    //look through all the args and see if anything in invalid
    _.each(arguments, function (arg) {
      if (typeof arg === 'undefined' || arg === null) {
        isValid = false;
      }
    });
    return isValid;
  },
  /***
   * isNotValid - indicates if any of the arguments are undefined or null
   *  usage - _.isNotValid(a,b,c)
   *  returns true if a, b, or c are undefined or null
   * @returns {Boolean}
   */
  isNotValid: function () {
    var isNotValid = false; //assume it is valid
    //look through all the args, if anything is not valid, flag it
    _.each(arguments, function (arg) {
      if (typeof arg === 'undefined' || arg === null) {
        isNotValid = true;
      }
    });
    return isNotValid;
  },
  capitalize: function (string) {
    return string.charAt(0).toUpperCase() + string.substring(1).toLowerCase();
  },
  /***
   * _.fuzzy - compares a string against a pattern
   *   example: fuzzy("fogo","foo") returns true
   * @param str - a string to be compared against a pattern
   * @param pattern - the pattern to verify against the string
   * @returns {boolean} - true of the pattern matches
   */
  fuzzy: function (str, pattern) {
    pattern = pattern.split("").reduce(function (a, b) {
      return a + ".*" + b;
    });
    return (new RegExp(pattern)).test(str);
  },
  // Get/set the value of a nested property
  // Usage:
  //
  // var obj = {
  //   a: {
  //     b: {
  //       c: {
  //         d: ['e', 'f', 'g']
  //       }
  //     }
  //   }
  // };
  //
  // Get deep value
  // _.deep(obj, 'a.b.c.d[2]'); // 'g'
  //
  // Set deep value
  // _.deep(obj, 'a.b.c.d[2]', 'george');
  //
  // _.deep(obj, 'a.b.c.d[2]'); // 'george'
  deep: function (obj, key, value) {

    var keys = key.replace(/\[(["']?)([^\1]+?)\1?\]/g, '.$2').replace(/^\./, '').split('.'),
      root,
      i = 0,
      n = keys.length;

    // Set deep value
    if (arguments.length > 2) {

      root = obj;
      n--;

      while (i < n) {
        key = keys[i++];
        obj = obj[key] = _.isObject(obj[key]) ? obj[key] : {};
      }

      obj[keys[i]] = value;

      value = root;

      // Get deep value
    } else {
      value = keys.reduce(function (o, x) {
        return (typeof o === 'undefined' || o === null) ? o : o[x];
      }, obj);
    }

    return value;
  },
  // Usage:
  //
  // var arr = [{
  //   deeply: {
  //     nested: 'foo'
  //   }
  // }, {
  //   deeply: {
  //     nested: 'bar'
  //   }
  // }];
  //
  // _.pluckDeep(arr, 'deeply.nested'); // ['foo', 'bar']
  pluckDeep: function (obj, key) {
    return _.map(obj, function (value) { return _.deep(value, key); });
  }
});

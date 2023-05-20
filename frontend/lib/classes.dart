// FOR CLASSES

class RandomText {
  String? text;

  RandomText(this.text);

  getText() {
    return this.text;
  }
}

class AccomCardDetails {
  String ID;
  String name;
  String description;
  String image;
  double rating;
  bool isSigned;

  AccomCardDetails(this.ID, this.name, this.description, this.image,
      this.rating, this.isSigned);

  getName() {
    return name;
  }

  getDescription() {
    return description;
  }

  getImage() {
    return image;
  }

  getID() {
    return ID;
  }

  getRating() {
    return rating;
  }
}

class Filter {
  double? rating;
  String? location;
  String? establishmentType;
  String? tenantType;
  double? minPrice;
  double? maxPrice;

  Filter(this.rating, this.location, this.establishmentType, this.tenantType,
      this.minPrice, this.maxPrice);

  isEmpty() {
    if (rating == null &&
        location == null &&
        establishmentType == null &&
        tenantType == null &&
        minPrice == null &&
        maxPrice == null) return true;
    return false;
  }

  getFiltersApplied() {
    return [
      [rating, "Rating"],
      [location, "Location"],
      [establishmentType, "Establishment Type"],
      [tenantType, "Tenant Type"],
      [minPrice, "Min Price"],
      [maxPrice, "Max Price"]
    ];
  }

  getRating() {
    return rating;
  }

  getLocation() {
    return location;
  }

  getEstablishmentType() {
    return establishmentType;
  }

  getTenantType() {
    return tenantType;
  }

  getMinPrice() {
    return minPrice;
  }

  getMaxPrice() {
    return maxPrice;
  }
}

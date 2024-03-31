class AddExpenseModel {
  AddExpenseModel(
      {this.createdBy,
      this.verifiedOn,
      this.isVerified,
      this.amount,
      this.createdOn,
      this.expenseheadId,
      this.id,
      this.imageUrl,
      this.verifiedBy});
  String? createdOn;
  String? verifiedOn;
  String? isVerified;
  String? expenseheadId;
  String? imageUrl;
  String? amount;
  String? id;
  String? createdBy;
  String? verifiedBy;

  AddExpenseModel.fromJson(Map<String, dynamic> json) {
    createdOn = json['CreatedOn'];
    verifiedOn = json['VerifiedOn'];
    isVerified = json['IsVerified'];
    expenseheadId = json['ExpenseHeadId'];
    imageUrl = json['ImageUrl'];
    amount = json['Amount'];
    id = json['Id'];
    createdBy = json['CreatedBy'];
    verifiedBy = json['VerifiedBy'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['CreatedOn'] = createdOn ?? DateTime.now().toString();
    data['VerifiedOn'] = verifiedOn ?? DateTime.now().toString();
    data['IsVerified'] = isVerified ?? false;
    data['ExpenseHeadId'] = expenseheadId;
    data['ImageUrl'] = imageUrl ?? "no";
    data['Amount'] = amount;
    data['Id'] = id ?? "00000000-0000-0000-0000-000000000000";
    data['CreatedBy'] = createdBy ?? "00000000-0000-0000-0000-000000000000";
    data['VerifiedBy'] = verifiedBy ?? "00000000-0000-0000-0000-000000000000";
    return data;
  }
}

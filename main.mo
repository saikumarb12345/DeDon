import Dom "mo:base/Dom";
import Debug "mo:base/Debug";

actor Fund {
  var fund : Nat = 0;

  public func add(amount: Nat) : async {
    fund := fund + amount;
  }; 

  public func checkEligibility(amount: Nat) : async Bool {
    return (fund >= amount);
  };

  public func withdraw(amount: Nat) : async {
    fund -= amount;
  };
};

actor Main {
  public func init() : async {
    let myFund = Fund{};
    let doc = Dom.document;
    let fundLeft = doc.getElementById("fund-left");
    let donateBtn = doc.getElementById("donate-btn");
    let donationAmount = doc.getElementById("donation-amount");
    let checkBtn = doc.getElementById("check-btn");
    let withdrawBtn = doc.getElementById("withdraw-btn");
    let withdrawalAmount = doc.getElementById("withdrawal-amount");

    // Update fund left(crypto currency) on the webpage
    func updateFundLeft() : async {
      let fund = await myFund.fund();
      fundLeft.textContent := "Fund Left: " # Nat.toText(fund);
    };

    // Add donation to the fund iterms of crypto
    func addDonation() : async {
      let amount = Nat.fromString(donationAmount.value);
      if (amount != null) {
        await myFund.add(amount);
        updateFundLeft();
        donationAmount.value := "";
      }
    };

    // Check eligibility for withdrawal crypto
    func checkEligibility() : async {
      let amount = Nat.fromString(withdrawalAmount.value);
      if (amount != null) {
        let isEligible = await myFund.checkEligibility(amount);
        withdrawBtn.disabled := !isEligible;
      }
    };

    // Performing withdrawal
    func withdraw() : async {
      let amount = Nat.fromString(withdrawalAmount.value);
      if (amount != null) {
        await myFund.withdraw(amount);
        updateFundLeft();
        withdrawalAmount.value := "";
        withdrawBtn.disabled := true;
      }
    };

    donateBtn.addEventListener("click", (_) => addDonation());
    checkBtn.addEventListener("click", (_) => checkEligibility());
    withdrawBtn.addEventListener("click", (_) => withdraw());

    // Initialize fund left updatation
    updateFundLeft();
  };
};

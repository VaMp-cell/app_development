const prompt = require('prompt-sync')({sigint: true}); // allows Ctrl+C exit
let data = [];

function menu() {
    let choice;
        console.log("\n=== CRUD Menu ===");
        console.log("1. Add Item");
        console.log("2. Show Items");
        console.log("3. Modify Item");
        console.log("4. Remove Item");
        console.log("5. Exit");

    do {
        choice = prompt("Choose an option (1-5): ");

        switch (choice) {
            case "1": // CREATE
                let item = prompt("Enter the item to add: ").trim();
                if(item) {
                    data.push(item);
                    console.log(`✅ "${item}" has been added.`);
                } else {
                    console.log("❌ Empty input! Item not added.");
                }
                break;

            case "2": // READ
                if (data.length === 0) {
                    console.log("No items to display.");
                } else {
                    console.log("Current Items:");
                    data.forEach((itm, idx) => {
                        console.log(`${idx}: ${itm}`);
                    });
                }
                break;

            case "3": // UPDATE
                if (data.length === 0) {
                    console.log("No items to update.");
                    break;
                }
                let updateIndex = parseInt(prompt("Enter the index of the item to update: "));
                if (updateIndex >= 0 && updateIndex < data.length) {
                    let newValue = prompt("Enter the new value: ").trim();
                    if(newValue) {
                        console.log(`"${data[updateIndex]}" will be updated to "${newValue}"`);
                        data[updateIndex] = newValue;
                        console.log("✅ Item updated successfully!");
                    } else {
                        console.log("❌ Empty input! Update cancelled.");
                    }
                } else {
                    console.log("❌ Invalid index!");
                }
                break;

            case "4": // DELETE
                if (data.length === 0) {
                    console.log("No items to delete.");
                    break;
                }
                let deleteIndex = parseInt(prompt("Enter the index of the item to delete: "));
                if (deleteIndex >= 0 && deleteIndex < data.length) {
                    console.log(`"${data[deleteIndex]}" will be removed.`);
                    data.splice(deleteIndex, 1);
                    console.log("✅ Item deleted successfully!");
                } else {
                    console.log("❌ Invalid index!");
                }
                break;

            case "5": // EXIT
                console.log("Exiting program... Goodbye!");
                break;

            default:
                console.log("❌ Invalid choice! Please select 1-5.");
        }
    } while (choice !== "5");
}

menu();
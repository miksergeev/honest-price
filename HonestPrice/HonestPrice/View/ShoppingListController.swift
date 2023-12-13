import UIKit

class ShoppingListController: UITableViewController {
    // хранение данных
    var storage = Storage()
    // список
    var shoppingList : [ProductShoppingListStruct] = []
    
    override func viewWillAppear(_ animated: Bool) {
        loadShoppingList()
        tableView.reloadData()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    private func loadShoppingList() {
        shoppingList = storage.load()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //print(shoppingList.count)
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shoppingList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getConfiguredCell(for: indexPath)

    }
    
    private func getConfiguredCell(for indexPath: IndexPath) -> UITableViewCell {
        // загружаем прототип ячейки по идентификатору
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingListCell", for: indexPath)
        // получаем данные о продукте, который нужно вывести
        let currentProduct = shoppingList[indexPath.row]
        
        let nameLabel = cell.viewWithTag(1) as? UILabel
        let priceLabel = cell.viewWithTag(2) as? UILabel
        
        nameLabel?.text = currentProduct.productName
        priceLabel?.text = currentProduct.honestPrice
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    // действие удаления
        let actionDelete = UIContextualAction(style: .destructive, title: "Удалить") { [self] _,_,_ in
     // удаляем товар
        self.shoppingList.remove(at: indexPath.row)
            print(self.shoppingList)
    // заново формируем табличное представление
        tableView.reloadData()
        storage.save(products: self.shoppingList)
        }
    // формируем экземпляр, описывающий доступные действия
    let actions = UISwipeActionsConfiguration(actions: [actionDelete]) 
    return actions
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


import Foundation

let nestEndingString = "Do_Not_Nest_From_Now"
var nestFlagString = "Do_Not_Nest_From_Now"
var classNo=1
let path0 = "/Users/apple20/Desktop/Json/Log.json"
let path1 = "/Users/apple20/Desktop/Js  on/Json/main.swift "
let jsonData = try!Data(contentsOf: URL(fileURLWithPath: path0))
var dictSet:[String:String]=["":""]
var numSet:[String:Int]=["":0]
var valueSet : [String:[[String:Any]]] = ["" : [[:]]]
var containSet : [String:[String]] = [:]
var attrSet : [String:String] = [:]
var totalSet : [String:String] = [:]
var text = ""
func changeClass(type:String,key:String) -> String{
    if(type=="__NSArrayM") {
        classNo+=1
        nestFlagString = key
        return "[Class\(classNo)]"
        
    }
    if(type=="__NSCFNumber"){
        return "Int"
    }
    return "String"
}
do{
    let jsonObj = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! NSDictionary
    text.append("struct Log {\n")
    //    print("struct Log{")
    for str in jsonObj.allKeys{
        let ty = "\(type(of: jsonObj[str]!))"
        let tmp = "\(changeClass(type:ty,key: "\(str)"))"
        if(ty=="__NSArrayM"){
            totalSet["\(str)"]="__NSArrayM"
        } else {totalSet["\(str)"] = "\(jsonObj[str]!)"}
        text.append("\tvar \(str): \(tmp)\n")
        
        //        print("\tvar \(str): \(changeClass(type:ty,key: "\(str)"))")
    }
    text.append("}\n")
    
    //    print("}")
    while(nestFlagString != nestEndingString){
        dictSet["Class\(classNo)"] = nestFlagString
        let data = jsonObj[nestFlagString] as! [[String:Any]]
        numSet["Class\(classNo)"] = data.count
        
        nestFlagString = nestEndingString
        text.append("struct Class\(classNo){\n")
        //        print("struct Class\(classNo){")
        var StrTmp :[String] = []
        for str in data[0].keys{
            let ty = "\(type(of:data[0][str]!))"
            StrTmp.append("\(str)")
            let attr = "\(changeClass(type:ty,key: "\(str)"))"
            text.append("\tvar \(str): \(attr)\n")
            attrSet["\(str)"] = attr
            //            print("\tvar \(str): \(changeClass(type:ty,key: "\(str)"))")
        }
        containSet["Class\(classNo)"] = StrTmp
        valueSet["Class\(classNo)"] = data
        text.append("}\n")
        //        print("}")
        
        
        
        print(text)
    }
    try text.write(toFile: path1, atomically: true, encoding: .utf8)
    print(text)
} catch{
    print("fail to decoder")
}





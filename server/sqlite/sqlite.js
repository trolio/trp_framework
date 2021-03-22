const updateUser = (identifier, newData) => {
    for (key in newData) {
        emit("trp_sqlite:updateUserData", identifier, key, newData[key])
    }
}
onabort("trp_sqlite:updateUser", updateUser)